path = require 'path'
fs = require 'fs'
{ spawn, exec } = require 'child_process'

printLine = (line) -> process.stdout.write line + '\n'
printWarn = (line) -> process.stderr.write line + '\n'

printIt = (buffer) -> printLine buffer.toString().trim()

titaniumPath = ->

  envVarName = 'TITANIUM_DIR'

  if titaniumDir = process.env[envVarName]
    titanium = path.join titaniumDir, 'titanium.py'
  else
    throw "#{envVarName} environment variable must be set."

runAndWatch = (spawnChild) ->

  child = spawnChild()

  restartFile = 'tmp/restart.txt'

  fs.watch restartFile, (curr, prev) ->
    console.log "Detected change to #{restartFile}. Restarting..."
    child.kill()
    child = spawnChild()

  console.log "Watching #{restartFile} for timestamp changes."

module.exports =

  command: require './command'

  tasks:

    bootstrap: require('./util/bootstrap').bootstrap

    "iphone:run": ->

      runAndWatch ->

        simulator = spawn titaniumPath(), [
          'run'
          '--platform=iphone'
        ]

        simulator.stdout.on 'data', printIt
        simulator.stderr.on 'data', printIt

        simulator.on 'exit', (code, signal) ->
          simulator.stdin.end()

        simulator
