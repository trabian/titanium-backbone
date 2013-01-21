path = require 'path'
fs = require 'fs'
util = require 'util'
_ = require 'underscore'

{ spawn, exec } = require 'child_process'

printLine = (line) -> process.stdout.write line + '\n'
printWarn = (line) -> process.stderr.write line + '\n'

printIt = (buffer) -> printLine buffer.toString().trim()

stylusConverter = require './converter/stylus'

titaniumPath = "node_modules/.bin/titanium"

runAndWatch = (onRun) ->

  onRun (_child) ->

    child = _child

    tmpPath = 'tmp'
    restartFile = "#{tmpPath}/restart.txt"

    createTmpDir = (cb) ->

      fs.exists tmpPath, (exists) ->
        if exists
          cb()
        else
          fs.mkdir 'tmp', (err) ->
            throw err if err
            cb()

    makeRestart = (cb) ->

      fs.writeFile restartFile, '', (err) ->
        throw err if err
        cb()

    watchRestart = ->

      fs.watch restartFile, (curr, prev) ->
        console.log "Detected change to #{restartFile}. Restarting..."
        child.kill()
        onRun (_child) ->
          child = _child

    createTmpDir ->

      fs.exists restartFile, (exists) ->
        if exists
          watchRestart()
        else
          makeRestart watchRestart

    console.log "Watching #{restartFile} for timestamp changes."

copyTiappIfNeeded = (callback) ->

  buildPath = 'build/iphone'
  appPath = path.join buildPath, 'tiapp.xml'

  fs.exists appPath, (exists) ->
    if exists
      callback()
    else

      fs.mkdir 'build', (err) ->

        throw err if err

        fs.mkdir buildPath, (err) ->

          throw err if err

          input = fs.createReadStream 'tiapp.xml'
          output = fs.createWriteStream appPath

          util.pump input, output, callback

module.exports =

  command: require './command'

  load: (root, pkg) ->

    options = _({}).extend pkg,
      compilers:
        styl: (module, filename) ->
          source = fs.readFileSync(filename, 'utf8')
          source = stylusConverter.convert source
          source = "module.exports = #{JSON.stringify source};"
          module._compile(source, filename)

    buildTasks = require('stitch-up').load(root, options).tasks

    runSimulator = (callback) ->

      simulator = spawn titaniumPath, [
        'build'
        '--platform=iphone'
      ]

      simulator.stdout.on 'data', printIt
      simulator.stderr.on 'data', printIt

      simulator.on 'exit', (code, signal) ->
        simulator.stdin.end()

      callback simulator

    bootstrap = require('./util/bootstrap').bootstrap

    tasks:

      bootstrap: bootstrap

      build: ->
        buildTasks.all()

      "build:test": ->
        buildTasks.test()

      "iphone:run": ->

        bootstrap pkg

        runAndWatch (callback) ->
          console.warn 'build tasks'
          buildTasks.stitch ->
            console.warn 'run simulator'
            runSimulator callback

      "iphone:run:nobuild": ->

        runAndWatch runSimulator
