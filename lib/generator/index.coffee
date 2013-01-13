path = require 'path'
fs = require 'fs'
pd = require('pretty-data').pd
wrench = require 'wrench'

underscorize = (str) ->
  str.toLowerCase().replace /[-\s]/g, '_'

dasherize = (str) ->
  str.toLowerCase().replace /[_\s]/g, '-'

urlToPackage = (url) ->
  url
    .replace(/http[s]?:\/\/(www\.)?/, '')
    .replace(/(www\.)?/, '')
    .split('.')
    .reverse()
    .join '.'

generateAppId = (options) ->
  urlToPackage(options.puburl) + '.' + underscorize options.name

buildPackage = (options) ->
  name: options.id
  version: '0.0.1'
  private: true
  description: 'Mobile app'
  dependencies:
    "titanium": "3.0.x"
    "titanium-backbone": "0.5.x"
    "titanium-backbone-ks": "0.1.x"
  stitch:
    identifier: 'stitchRequire'
    output:
      app: "Resources/app-impl.js"
      vendor: "Resources/lib"
      images: "Resources/images"
    paths: [ "src" ]
  mobile:
    id: options.id
    name: options.name
    puburl: options.puburl
  engine:
    node: ">= 0.6"

module.exports =

  app: (options) ->

    options.puburl or= "http://www.example.com"

    options.id or= generateAppId options

    options.dir or= "./#{dasherize options.name}"

    if options.puburl.substr(0,4) != 'http'
      options.puburl = 'http://' + options.puburl

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
              Done generating the app. Change to the new directory, install the packages, and build the .js files:

                $ cd #{options.dir}
                $ npm install

              Now you're ready to run a blank mobile app:

                $ cake t:iphone:run

            """
