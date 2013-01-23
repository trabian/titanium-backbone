fs = require 'fs'
stylus = require 'stylus'

converter = require './converter'

module.exports =

  build: (options, callback) ->

    if config = options.stylus

      fs.readFile config.main, 'utf8', (err, source) ->

        config.paths ?= []

        config.paths.push "#{__dirname}/../../styles"

        renderer = stylus(source)
          .set 'paths', config.paths

        if plugins = config.plugins

          for plugin in config.plugins
            if loadStyles = require(plugin)?.loadStyles
              renderer.use loadStyles

        converter.convertRenderer renderer, (err, out) ->
          fs.writeFile config.output, "STYLES = #{JSON.stringify(out, null, '  ')};", (err) ->

            if err
              console.warn 'err', err if err
            else
              console.log "Compiled #{options.stylus.output}"

            callback?()

