path = require 'path'
fs = require 'fs'
util = require 'util'
{ spawn, exec } = require 'child_process'

printLine = (line) -> process.stdout.write line + '\n'
printWarn = (line) -> process.stderr.write line + '\n'

printIt = (buffer) -> printLine buffer.toString().trim()

titaniumPath = ->

  envVarName = 'TITANIUM_DIR'

  if titaniumDir = process.env[envVarName]
    titanium = path.join titaniumDir, 'titanium.py'
  else
    console.log "#{envVarName} environment variable must be set."
    process.exit()

runAndWatch = (onRun) ->

  onRun (_child) ->

    child = _child

    restartFile = 'tmp/restart.txt'

    fs.watch restartFile, (curr, prev) ->
      console.log "Detected change to #{restartFile}. Restarting..."
      child.kill()
      onRun (_child) ->
        child = _child

    console.log "Watching #{restartFile} for timestamp changes."

copyTiappIfNeeded = (callback) ->

  buildPath = 'build/iphone'
  appPath = path.join buildPath, 'tiapp.xml'

  path.exists appPath, (exists) ->
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

    buildTasks = require('stitch-up').load(root, pkg).tasks

    runSimulator = (platform, callback) ->

      simulator = spawn titaniumPath(), [
        'run'
        "--platform=#{platform}"
      ]

      simulator.stdout.on 'data', printIt
      simulator.stderr.on 'data', printIt

      simulator.on 'exit', (code, signal) ->
        simulator.stdin.end()

      callback simulator

    tasks:

      bootstrap: require('./util/bootstrap').bootstrap

      build: ->
        buildTasks.all()

      "build:test": -> buildTasks.test()

      "iphone:run": ->

        copyTiappIfNeeded ->
          runAndWatch (callback) ->
            buildTasks.stitch -> runSimulator 'iphone', callback

      "iphone:run:nobuild": ->

        copyTiappIfNeeded ->
          runAndWatch runSimulator

      "android:run": ->

        copyTiappIfNeeded ->
          runAndWatch (callback) ->
            buildTasks.stitch -> runSimulator 'android', callback
