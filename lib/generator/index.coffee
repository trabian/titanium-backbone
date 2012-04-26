path = require 'path'
fs = require 'fs'
pd = require('pretty-data').pd
wrench = require 'wrench'

dasherize = (str) ->
  str.toLowerCase().replace /[_\s]/g, '-'

buildPackage = (options) ->
  name: options.id
  version: '0.0.1'
  private: true
  description: 'Mobile app'
  dependencies:
    "titanium-backbone": "0.1.x"
    "titanium-backbone-ks": "0.0.x"
  stitch:
    identifier: 'mobileRequire'
    output:
      app: "Resources/app-impl.js"
      vendor: "Resources/lib"
      images: "Resources/images"
    paths: [ "src" ]
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

        wrench.copyDirRecursive "#{__dirname}/_template", options.dir, ->

          writeFile 'package.json', (pd.json JSON.stringify buildPackage(options)), ->

            console.log """
              Done generating the app. Change to the new directory and install the packages:

                $ cd #{options.dir}
                $ npm install

              Now you're ready to run a blank mobile app:

                $ cake t:iphone:run

            """
