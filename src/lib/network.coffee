module.exports =

  request: (url, options) ->

    # Build an xhr object similar to the one returned by jQuery's ajax methods.
    # This allows the use of deferreds.
    xhr = {}

    deferred = new Deferred()

    _(xhr).extend deferred.promise()

    xhr.success = xhr.done

    options.timeout ?= 1000000
    options.type ?= 'GET'
    options.data ?= null

    xhr.done (data, responseText, status) ->
      options.success data, status, client

    xhr.fail (e) ->
      console.log 'error', e

    client = Ti.Network.createHTTPClient

      timeout: options.timeout

      onload: ->

        data = JSON.parse @responseText

        deferred.resolve data, @status, xhr

      onerror: (e) ->
        deferred.reject e

    client.open options.type, url, true

    if options.contentType
      client.setRequestHeader 'Content-Type', options.contentType

    if auth = options.auth

      authString = Ti.Utils.base64encode [auth.login, auth.password].join ':'

      client.setRequestHeader 'Authorization', "Basic #{authString}"

    client.send options.data

    xhr
