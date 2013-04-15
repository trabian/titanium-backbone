errorHandler = require './error_handler'

module.exports =

  request: (url, options, xhr, deferred) ->

    # Build an xhr object similar to the one returned by jQuery's ajax methods.
    # This allows the use of deferreds.

    unless xhr

      xhr = {}

      deferred = new Deferred()

      _(xhr).extend deferred.promise()

      xhr.success = xhr.done

      xhr.done (data, status, client) ->
        options.success? data, status, client

      xhr.fail (e, responseText, status) =>
        options.error? e, responseText, status

    options.timeout ?= 1000000
    options.type ?= 'GET'
    options.data ?= null
    options.contentType ?= 'application/json'

    client = Ti.Network.createHTTPClient

      timeout: options.timeout

      onload: ->

        data = if options.contentType is 'application/json'
          JSON.parse @responseText
        else
          @responseData

        deferred.resolve data, @status, xhr
        return

      onsendstream: (e) ->
        options.progress? e.progress
        return

      onerror: (e) ->

        errorHandled = errorHandler.handleError @responseText, @status, =>
          module.exports.request url, options, xhr, deferred

        deferred.reject e, @responseText, @status unless errorHandled

        return

      onreadystatechange: (e) ->
        client.onload() if @readyState is Ti.Network.HTTPClient?.DONE
        return

    client.open options.type, url, true

    if options.contentType
      client.setRequestHeader 'Content-Type', options.contentType

    if headers = options.headers
      for name, value of headers
        client.setRequestHeader name, value

    options.beforeSend? client

    if auth = options.auth

      authString = Ti.Utils.base64encode [auth.login, auth.password].join ':'

      client.setRequestHeader 'Authorization', "Basic #{authString}"

    client.send options.data

    xhr
