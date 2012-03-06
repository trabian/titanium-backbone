jade = require 'jade'
path = require 'path'
pd = require('pretty-data').pd
fs = require 'fs'
uuid = require 'node-uuid'

createTiapp = (options) ->

  tiapp = 'tiapp.xml'

  path.exists tiapp, (exists) ->

    if exists
      console.log "#{tiapp} already exists, so the bootstrap process isn't needed."

    else

      options =
        guid: uuid.v4()
        id: options.id
        name: options.name

      jade.renderFile "#{__dirname}/tiapp.jade", options, (err, str) ->
        throw err if err
        fs.writeFile tiapp, (pd.xml str), (err) ->
          throw err if err
          console.log "Successfully created #{tiapp}. Be sure to edit the items in [brackets]."

module.exports =

  bootstrap: (package) ->

    createTiapp package.mobile

    for resourceDir in ['iphone', 'android']

      do (resourceDir) ->

        dirName = "Resources/#{resourceDir}"

        path.exists dirName, (exists) ->

          if exists
            console.log "#{dirName} already exists. Skipping creation."
          else
            fs.mkdir dirName, (err) ->
              throw err if err
              console.log "Created #{dirName}"
