util = require 'lib/util'
network = require 'lib/network'

methodMap =
  create: 'POST'
  update: 'POST'
  delete: 'POST'
  read: 'GET'

module.exports = class Sync

  constructor: (@options = {}) ->

    @options.parse ?= (response) ->
      response

  buildUrl: (url) =>

    if urlRoot = @options.urlRoot

      divider = if urlRoot.match(/\/$/) then '' else '/'

      url = url.replace /^\//, ''

      url = [urlRoot, url].join divider

    url

  sync: (method, model, options) =>

    url = @buildUrl options.url ? _.result model, 'url'

    if not options.data and model and method in ['create', 'update']

      data = JSON.stringify model.toJSON()

    if data
      contentType = 'application/json'

    network.request url,

      type: methodMap[method]

      data: data

      contentType: contentType

      timeout: options.timeout

      beforeSend: @options.beforeSend

      success: (data, status, client) =>

        data = @options.parse data

        options.success? data, status, client
