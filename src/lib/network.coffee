module.exports =

  request: (url, options) ->

    options.timeout ?= 1000000
    options.type ?= 'GET'
    options.data ?= null

    xhr = Ti.Network.createHTTPClient

      timeout: options.timeout

      onload: ->

        data = JSON.parse @responseText

        options.success data, @status, xhr

      onerror: (e) ->

        console.log 'error', e

    xhr.open options.type, url, true

    if auth = options.auth

      authString = Ti.Utils.base64encode [auth.login, auth.password].join ':'

      xhr.setRequestHeader 'Authorization', "Basic #{authString}"

    xhr.send options.data
