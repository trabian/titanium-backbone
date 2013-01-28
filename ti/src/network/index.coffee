StatusCodes =
  200: 'OK'
  201: 'Created'
  202: 'Accepted'
  203: 'Non-Authoritative Information'
  204: 'No Content'
  205: 'Reset Content'
  206: 'Partial Content'
  300: 'Multiple Choices'
  301: 'Moved Permanently'
  302: 'Found'
  303: 'See Other'
  304: 'Not Modified'
  305: 'Use Proxy'
  307: 'Temporary Redirect'
  400: 'Bad Request'
  401: 'Unauthorized'
  402: 'Payment Required'
  403: 'Forbidden'
  404: 'Not Found'
  405: 'Method Not Allowed'
  406: 'Not Acceptable'
  407: 'Proxy Authentication Required'
  408: 'Request Timeout'
  409: 'Conflict'
  410: 'Gone'
  411: 'Length Required'
  412: 'Precondition Failed'
  413: 'Request Entity Too Large'
  414: 'Request-URI Too Long'
  415: 'Unsupported Media Type'
  416: 'Requested Range Not Satisfiable'
  417: 'Expectation Failed'
  500: 'Internal Server Error'
  501: 'Not Implemented'
  502: 'Bad Gateway'
  503: 'Service Unavailable'
  504: 'Gateway Timeout'
  505: 'HTTP Version Not Supported'

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

      @statusText = StatusCodes[@status]

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

