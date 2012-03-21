util = require 'lib/util'

methodMap =
  create: 'POST'
  update: 'POST'
  delete: 'POST'
  read: 'GET'

getValue = (object, prop) ->
  if val = object?[prop]
    if _.isFunction(val) then val() else val
  else
    null

module.exports = (method, model, options) ->

  type = methodMap[method]

  url = options.url ? getValue model, 'url'

  if not options.data and model and method in ['create', 'update']

    data = JSON.stringify model.toJSON()

  xhr = Ti.Network.createHTTPClient

    timeout: options.timeout or 1000000

    onload: ->

      data = JSON.parse @responseText

      console.log 'data', data

      options.success data, @status, xhr

    onerror: (e) ->

      console.log 'error', e

  xhr.open type, url, true

  if auth = options.auth

    authString = Ti.Utils.base64encode [auth.login, auth.password].join ':'

    xhr.setRequestHeader 'Authorization', "Basic #{authString}"

  xhr.send data
