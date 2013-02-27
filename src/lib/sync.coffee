util = require 'lib/util'
network = require 'lib/network'

methodMap =
  create: 'POST'
  update: 'POST'
  delete: 'DELETE'
  read: 'GET'

module.exports = class Sync

  constructor: (@options = {}) ->

    @options.parse ?= (response) ->
      response

  buildUrl: (url) =>

    if (urlRoot = @options.urlRoot) and not url.match /^https?:\/\//

      divider = if urlRoot.match(/\/$/) then '' else '/'

      url = url.replace /^\//, ''

      url = [urlRoot, url].join divider

    url

  sync: (method, model, options) =>

    url = @buildUrl options.url ? _.result model, 'url'
    contentType = options.contentType ? _.result model, 'contentType'

    data = options.data

    if not options.data and model and method in ['create', 'update']

      data = JSON.stringify model.toJSON()

    if data
      contentType ?= 'application/json'

    network.request url,

      type: methodMap[method]

      data: data

      contentType: contentType

      headers: options.headers ? {}

      timeout: options.timeout

      beforeSend: @options.beforeSend

      error: (e, responseText, status) =>
        @options.error e, responseText, status
        options.error? e, responseText, status

      progress: @options.progress

      success: (data, status, client) =>

        data = @options.parse data

        model?.lastUpdated = new Date()

        options.success? data, status, client
