pkg = require './package'

buildTasks = require('stitch-up').load(root, pkg).tasks

task "build", ->
  buildTasks.all()

task "build:test", ->
  buildTasks.test()
