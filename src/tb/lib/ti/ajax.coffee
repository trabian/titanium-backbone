module.exports = ($) ->

  _.extend $,

    ajaxSettings:
      type: 'GET'
      converters:
        json: JSON.parse
        text: _.identity

    ajaxConvert: (type, text) ->
      converter = @ajaxSettings.converters[type] or _.identity
      try
        converter? text
      catch e
        '[Parse error]'

    ajax: (url, options = {}) ->

      xhr = {}
      s = {}

      deferred = new Deferred()

      _(xhr).extend deferred.promise()

      xhr.done ->
        options.success?.apply @, arguments

      xhr.fail ->
        options.error?.apply @, arguments

      s = @ajaxSettings

      dataType = options.dataType ? 'text'
      s.type = options.method or options.type or s.method or s.type

      client = Ti.Network.createHttpClient

        onload: (e) ->
          data = $.ajaxConvert dataType, @responseText
          deferred.resolve data, null, @

        onerror: (e) ->
          data = $.ajaxConvert dataType, @responseText
          deferred.reject data, null, @

      client.open s.type, url

      client.send options.data

      xhr
