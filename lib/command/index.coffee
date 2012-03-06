_ = require 'underscore'

commands =
  new: require './new'

module.exports =

  run: (args) ->

    commandName = args.splice 2, 1

    if command = commands[commandName]
      command.run args

    else
      console.log "Couldn't find command: #{commandName}"
