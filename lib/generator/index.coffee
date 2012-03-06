path = require 'path'
fs = require 'fs'
pd = require('pretty-data').pd

dasherize = (str) ->
  str.toLowerCase().replace /[_\s]/g, '-'

buildPackage = (options) ->
  name: options.id
  version: '0.0.1'
  private: true
  description: 'Mobile app'
  dependencies:
    "titanium-backbone": "git+ssh://git@github.com:trabian/titanium-backbone.git#master"
    "stitch-up": "git+ssh://git@github.com:trabian/stitch-up.git#master"
  stitch:
    output:
      app: "Resources/app-impl.js"
      vendor: "Resources/lib"
    paths: [ "src" ]
  engine:
    node: ">= 0.6"

module.exports =

  app: (options) ->

    options.id or= dasherize options.name

    options.dir or= "./#{options.id}"

    path.exists options.dir, (exists) ->

      writeFile = (name, contents) ->

        filePath = path.join options.dir, name

        fs.writeFile filePath, contents, (err) ->
          throw err if err
          console.log "Created #{filePath}"

      if exists
        console.log "#{options.dir} already exists. Aborting."
        process.exit()

      else

        console.log "Creating #{options.dir}"

        fs.mkdir options.dir, (err) ->

          throw err if err

          writeFile '.gitignore', '''
            node_modules

          '''

          writeFile 'package.json', pd.json JSON.stringify buildPackage(options)

          writeFile 'Cakefile', '''
            build = require('stitch-up').load __dirname, require './package'

            titanium = require 'titanium-backbone'

            for _task, func of build.tasks
              task "build:#{_task}", func

            for _task, func of titanium.tasks
              task "t:#{_task}", func

          '''
