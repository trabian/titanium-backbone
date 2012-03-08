package = require './package'

titanium = require('titanium-backbone').load __dirname, package

for _task, func of titanium.tasks
  do (func) ->
    task "t:#{_task}", -> func package

task "build", ->
  invoke "t:bootstrap"
  invoke "t:build"
