class TitaniumHttpClient

  @mock: (@mocks, @options = {}) ->

  @resetMock: ->
    @mocks = []

  constructor: (@options) ->
    @headers = {}

  open: (@method, @url, @async) ->

  abort: -> @aborted = true

  send: (data) ->

    @responseHeaders = {}

    mock = _.find TitaniumHttpClient.mocks, (mock) =>
      mock.method is @method and @url.match mock.url

    handleResponse = =>

      @status ?= 200

      handler = if @status in [200]
        'onload'
      else
        'onerror'

      @options[handler]?.call @,
        source: @

    unless mock
      @status = 501
      handleResponse()
      return

    response = if _.isFunction mock.response
      mock.response data, @
    else
      mock.response

    _.extend @, response

    @responseHeaders['Content-Type'] = response.contentType or 'text/json'

    if @async and wait = TitaniumHttpClient.options.wait
      setTimeout handleResponse, wait
    else
      handleResponse()

  setRequestHeader: (name, value) -> @headers[name] = value

  getResponseHeader: (name) -> @responseHeaders[name]

Ti.Network =

  HTTPClient: TitaniumHttpClient

  createHttpClient: (options) ->
    new TitaniumHttpClient options

