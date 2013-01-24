class TitaniumHttpClient

  @mock: (@mocks, @options = {}) ->

  @resetMock: ->
    @mocks = []

  constructor: (@options) ->

  open: (@method, @url) ->

  send: (data) ->

    mock = _.find TitaniumHttpClient.mocks, (mock) =>
      mock.url is @url and mock.method is @method

    handleResponse = =>

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
      mock.response data
    else
      mock.response

    _.extend @, response

    if wait = TitaniumHttpClient.options.wait
      setTimeout handleResponse, wait
    else
      handleResponse()

Ti.Network =

  HTTPClient: TitaniumHttpClient

  createHttpClient: (options) ->
    new TitaniumHttpClient options

