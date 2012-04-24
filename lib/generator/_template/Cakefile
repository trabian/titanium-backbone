pkg = require './package'

titanium = require('titanium-backbone').load __dirname, pkg

for _task, func of titanium.tasks
  do (func) ->
    task "t:#{_task}", -> func pkg

task "build", ->
  invoke "t:bootstrap"
  invoke "t:build"
