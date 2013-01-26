handlers = require './handlers'

ajax_nonce = Date.now()

rts = /([?&])_=[^&]*/
ajax_rquery = /\?/
rnoContent = /^(?:GET|HEAD)$/
rprotocol = /^\/\//
rurl = /^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/

module.exports = ($) ->

  # A special extend for ajax options
  # that takes "flat" options (not to be deep extended)
  # Fixes #9887
  ajaxExtend = (target, src) ->

    deep = null

    flatOptions = $.ajaxSettings.flatOptions or {}

    for key, value of src

      if value?

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

      contents:
        xml: /xml/
        html: /html/
        json: /json/

      responseFields:
        xml: "responseXML"
        text: "responseText"

      async: true

      converters:
        '* text': String
        'text html': true
        'text json': JSON.parse
        'text xml': String

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

      requestHeaders = {}

      client = null
      callbackContext = @

      xhr =

        setRequestHeader: (name, value) ->
          requestHeaders[name] = value

        getRequestHeader: (name) ->
          requestHeaders[name]

        getResponseHeader: (name) -> @headers?[name]

        abort: (statusText) ->

          finalText = statusText or strAbort

          client?.abort()

          done 0, statusText

          @

      deferred = $.Deferred()

      completeDeferred = $.Callbacks('once memory')

      deferred.promise(xhr).complete = completeDeferred.add

      xhr.success = xhr.done
      xhr.error = xhr.fail

      done = (status, nativeStatusText, responses, headers) ->

        isSuccess = null
        client = null
        statusText = nativeStatusText
        response = null

        xhr.headers = headers

        if responses
          response = handlers.handleResponses s, xhr, responses

        if status >= 200 and status < 300 or status is 304

          if status is 304
            isSuccess = true
            statusText = 'notmodified'
          else

            isSuccess = handlers.convert s, response

            statusText = isSuccess.state
            success = isSuccess.data
            error = isSuccess.error

            isSuccess = ! error

        else

          error = statusText

          if status or ! statusText
            statusText = 'error'
            status = 0 if status < 0

        xhr.status = status
        xhr.statusText = (nativeStatusText or statusText) + ""

        if isSuccess
          deferred.resolveWith callbackContext, [success, statusText, xhr]
        else
          deferred.rejectWith callbackContext, [xhr, statusText, error]

        completeDeferred.fireWith callbackContext, [xhr, statusText]

      s = $.ajaxSetup {}, options

      s.url ?= url

      strAbort = 'canceled'

      dataType = options.dataType ? 'text'

      s.type = options.method or options.type or s.method or s.type
      s.dataTypes = (s.dataType or '*').trim().toLowerCase().match /\S+/g

      # Determine if request has content
      s.hasContent = ! rnoContent.test s.type

      for callback in ['success', 'error', 'complete']
        xhr[callback] s[callback]

      cacheURL = s.url

      unless s.hasContent

        if s.cache is false
          s.url = if rts.test cacheURL
            cacheURL.replace rts, "$1_=#{ajax_nonce++}"
          else
            cacheURL + (if ajax_rquery.test(cacheURL) then "&" else "?") + "_=" + ajax_nonce++

      handleClientResponse = ->

        headers = {}

        for name in ['Content-Type']
          headers[name] = @getResponseHeader name

        responses =
          text: @responseText
          xml: @responseXML

        done @status, @statusText, responses, headers

      client = Ti.Network.createHttpClient

        onload: (e) -> handleClientResponse.call @

        onerror: (e) -> handleClientResponse.call @

      client.open s.type, s.url, s.async

      xhr.setRequestHeader 'Accept',

        if (firstType = s.dataTypes[0]) and s.accepts[s.dataTypes[0]]

          accept = s.accepts[firstType]

          if firstType isnt '*'
            "#{accept}, */*; q=0.01"
          else
            accept

        else
          s.accepts['*']

      if s.beforeSend?.call(@, xhr, s) is false
        return xhr.abort()

      for key, value of requestHeaders
        client.setRequestHeader key, value

      client.send options.data

      xhr
