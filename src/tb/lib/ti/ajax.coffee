module.exports = ($) ->

  # A special extend for ajax options
  # that takes "flat" options (not to be deep extended)
  # Fixes #9887
  ajaxExtend = (target, src) ->

    deep = null

    flatOptions = $.ajaxSettings.flatOptions or {}

    for key, value of src

      if value

        _target = if flatOptions[key]
          target
        else
          (deep ?= {})

        _target[key] = value

    if deep
      jQuery.extend true, target, deep

    target

  _.extend $,

    ajaxSettings:

      type: 'GET'

      accepts:
        '*': '*/*'
        text: "text/plain"
        html: "text/html"
        xml: "application/xml, text/xml"
        json: "application/json, text/javascript"

      converters:
        json: JSON.parse
        text: _.identity

      flatOptions:
        url: true
        context: true

    ajaxSetup: (target, settings) ->
      if target

        # Building a settings object
        ajaxExtend ajaxExtend( target, $.ajaxSettings ), settings

      else

        # Extending ajaxSettings
        ajaxExtend $.ajaxSettings, target

    ajaxConvert: (type, text) ->
      converter = @ajaxSettings.converters[type] or _.identity
      try
        converter? text
      catch e
        '[Parse error]'

    ajax: (url, options = {}) ->

      xhr = {}
      s = $.ajaxSetup {}, options

      deferred = $.Deferred()

      _(xhr).extend deferred.promise()

      xhr.done ->
        options.success?.apply @, arguments

      xhr.fail ->
        options.error?.apply @, arguments

      dataType = options.dataType ? 'text'

      s.type = options.method or options.type or s.method or s.type
      s.dataTypes = (s.dataType or '*').trim().toLowerCase().match /\S+/g

      client = Ti.Network.createHttpClient

        onload: (e) ->
          data = $.ajaxConvert dataType, @responseText
          deferred.resolve data, null, @

        onerror: (e) ->
          data = $.ajaxConvert dataType, @responseText
          deferred.reject data, null, @

      # This will allow wrapping
      xhr.setRequestHeader = (name, value) ->
        client.setRequestHeader name, value

      client.open s.type, url

      xhr.setRequestHeader 'Accept',

        if (firstType = s.dataTypes[0]) and s.accepts[s.dataTypes[0]]

          accept = s.accepts[firstType]

          if firstType isnt '*'
            "#{accept}, */*; q=0.01"
          else
            accept

        else
          s.accepts['*']

      client.send options.data

      xhr
