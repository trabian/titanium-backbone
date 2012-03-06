path = require 'path'
fs = require 'fs'
pd = require('pretty-data').pd
async = require 'async'

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
    identifier: 'mobileRequire'
    output:
      app: "Resources/app-impl.js"
      vendor: "Resources/lib"
    paths: [ "src/app" ]
  mobile:
    id: options.id
    name: options.name
  engine:
    node: ">= 0.6"
  scripts:
    install: 'cake build'

module.exports =

  app: (options) ->

    options.id or= dasherize options.name

    options.dir or= "./#{options.id}"

    path.exists options.dir, (exists) ->

      writeFile = (name, contents, callback) ->

        filePath = path.join options.dir, name

        fs.writeFile filePath, contents, (err) ->
          throw err if err
          callback()

      mkdir = (name, callback) ->

        filePath = path.join options.dir, name

        fs.mkdir filePath, (err) ->
          throw err if err
          callback()

      if exists
        console.log "#{options.dir} already exists. Aborting."
        process.exit()

      else

        fs.mkdir options.dir, (err) ->

          throw err if err

          async.parallel [

            (callback) ->
              writeFile '.gitignore', '''
                node_modules
              ''', callback

            (callback) ->
              writeFile 'package.json', (pd.json JSON.stringify buildPackage(options)), callback

            (callback) ->
              mkdir 'src', ->

                async.parallel [

                  (childCallback) ->
                    mkdir 'src/app', ->
                      writeFile 'src/app/index.coffee', '''
                        module.exports =
                          run: ->
                            alert 'Hello World!'
                      ''', childCallback

                  (childCallback) -> mkdir 'src/properties', childCallback

                ], callback

            (callback) ->
              mkdir 'tmp', ->
                writeFile 'tmp/restart.txt', '', callback

            (callback) ->
              mkdir 'Resources', ->
                writeFile 'Resources/app.js', '''
                  Ti.include('app-impl.js');
                  this.mobileRequire('index').run();
                ''', callback

            (callback) ->
              writeFile 'Cakefile', '''
                package = require './package'

                build = require('stitch-up').load __dirname, package

                titanium = require 'titanium-backbone'

                for _task, func of build.tasks
                  do (func) ->
                    task "build:#{_task}", -> func package

                for _task, func of titanium.tasks
                  do (func) ->
                    task "t:#{_task}", -> func package

                task "build", ->
                  invoke "build:all"
                  invoke "t:bootstrap"
              ''', callback

          ], ->

            console.log """
              Done generating the app. Change to the new directory and install the packages:

                $ cd #{options.dir}
                $ npm install

              Now you're ready to run a blank mobile app:

                $ cake t:iphone:run

            """
