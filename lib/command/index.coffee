_ = require 'underscore'

commands =
  new: require './new'

module.exports =

  run: (args) ->

    commandName = args.splice 2, 1

    if command = commands[commandName]
      command.run args

    else

      commandList = _.map(_.keys(commands), (command) -> "'#{command}'").join ', '

      if _.isEmpty commandName
        console.log "Need to supply a command. Try one of these: #{commandList}"
      else
        console.log "Couldn't find command: #{commandName}. Try one of these: #{commandList}"
