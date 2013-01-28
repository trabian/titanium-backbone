# Portions copyright 2013 jQuery Foundation and other contributors
# http://jquery.com/

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

handlers = require './handlers'

ajax_nonce = Date.now()

rts = /([?&])_=[^&]*/
ajax_rquery = /\?/
rnoContent = /^(?:GET|HEAD)$/
rprotocol = /^\/\//
rurl = /^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/

module.exports = ($) ->

  callbackContext = null

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

      contentType: 'application/x-www-form-urlencoded; charset=UTF-8'

      converters:
        '* text': String
        'text html': true
        'text json': JSON.parse
        'text xml': String

      flatOptions:
        url: true
        context: true

      processData: true

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

      xhr =

        setRequestHeader: (name, value) ->
          requestHeaders[name] = value

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

      if s.data and s.processData and not _.isString s.data
        s.data = $.param s.data, s.traditional

      # Determine if request has content
      s.hasContent = ! rnoContent.test s.type

      callbackContext = s.context or s

      for callback in ['success', 'error', 'complete']
        xhr[callback] s[callback]

      cacheURL = s.url

      unless s.hasContent

        # If data is available, append data to url
        if s.data
          cacheURL = s.url += if ajax_rquery.test(cacheURL) then "&" else "?" + s.data
          # remove data so that it's not used in an eventual retry
          delete s.data;

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

      #  Set the correct header, if data is being sent
      if s.data and s.hasContent and s.contentType isnt false or options.contentType
        xhr.setRequestHeader "Content-Type", s.contentType

      xhr.setRequestHeader 'Accept',

        if (firstType = s.dataTypes[0]) and s.accepts[s.dataTypes[0]]

          accept = s.accepts[firstType]

          if firstType isnt '*'
            "#{accept}, */*; q=0.01"
          else
            accept

        else
          s.accepts['*']

      if s.beforeSend?.call(callbackContext, xhr, s) is false
        return xhr.abort()

      for key, value of requestHeaders
        client.setRequestHeader key, value

      client.send options.data

      xhr
