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

    if data and not options.multipart
      contentType ?= 'application/json'

    method = options.method ? methodMap[method]

    network.request url,

      type: method

      data: data

      multipart: options.multipart

      contentType: contentType

      headers: options.headers ? {}

      timeout: options.timeout

      accept: options.accept

      beforeSend: @options.beforeSend

      error: (e, responseText, status) =>

        if options.error?

          unless options.error(e, responseText, status) is false
            @options.error e, responseText, status

        else
          @options.error e, responseText, status

        return

      progress: @options.progress

      success: (data, status, client) =>

        data = @options.parse data

        model?.lastUpdated = new Date()

        options.success? data, status, client
