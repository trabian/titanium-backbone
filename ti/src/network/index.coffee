class TitaniumHttpClient

  @mock: (@mocks, @options = {}) ->

  @resetMock: ->
    @mocks = []

  constructor: (@options) ->

  open: (@method, @url) ->

  send: (data) ->

    mock = _.find TitaniumHttpClient.mocks, (mock) =>
      mock.url is @url and mock.method is @method

    _.extend @, mock.response

    handleResponse = =>
      @options.onload.call @,
        source: @

    if wait = TitaniumHttpClient.options.wait
      setTimeout handleResponse, wait
    else
      handleResponse()

Ti.Network =

  HTTPClient: TitaniumHttpClient

  createHttpClient: (options) ->
    new TitaniumHttpClient options

