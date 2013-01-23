module.exports = ($) ->

  _.extend $,

    ajaxSettings:
      type: 'GET'
      converters:
        json: JSON.parse
        text: _.identity

    ajaxConvert: (type, text) ->
      converter = @ajaxSettings.converters[type] or _.identity
      converter? text

    ajax: (url, options = {}) ->

      xhr = {}

      deferred = new Deferred()

      _(xhr).extend deferred.promise()

      xhr.done ->
        options.success?.apply @, arguments

      s = @ajaxSettings

      dataType = options.dataType ? 'text'
      method = options.method ? s.type

      client = Ti.Network.createHttpClient

        onload: (e) ->
          data = $.ajaxConvert dataType, @responseText
          deferred.resolve data, null, @

      client.open 'GET', url

      client.send()

      xhr
