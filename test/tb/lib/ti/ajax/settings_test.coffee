helpers = require '../../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'

$ = ti.$
Ti = ti.Ti

describe '$.ajax settings', ->

  beforeEach ->

    @originalSettings = _.clone $.ajaxSettings

    Ti.Network.HTTPClient.resetCaches()

    Ti.Network.HTTPClient.mock [
      url: '/test'
      method: 'GET'
      response:
        status: 200
        responseText:
          JSON.stringify
            test: 'This is a test'
    ,
      url: '/error'
      method: 'GET'
      response:
        status: 500
        responseText: 'This is an error'
    ], wait: 5

  afterEach ->
    Ti.Network.HTTPClient.resetMock()
    $.ajaxSettings = @originalSettings

  describe 'accepts and converters', ->

    beforeEach ->
      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          status: 200
          responseText: JSON.stringify { accept: xhr.headers['Accept'] }

    it 'should set the Accept request header', (done) ->

      settings =
        accepts:
          'custom': 'custom-request-type'
        dataType: 'custom text'
        converters:
          "* custom": _.identity

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.match data, /custom-request-type/
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should not overwrite existing request headers', (done) ->

      settings =
        accepts:
          custom: 'custom-request-type'
        dataType: 'text'
        converters:
          "* custom": _.identity

      $.ajax('/capture', settings).always (data, textStatus, xhr) ->
        assert.match data, /text\/plain/
        done()

    it 'should default to */*', (done) ->

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.equal data.accept, '*/*'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        accepts:
          'custom': 'custom-request-type'
        dataType: 'custom text'
        converters:
          "* custom": _.identity

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.match data, /custom-request-type/
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'async', ->

    it 'should default to true', (done) ->

      result = $.ajax('/test').always (data, textStatus, xhr) ->
        done()

      assert.equal result.state(), 'pending'

    it 'should be possible to set it to false', ->

      result = $.ajax '/test',
        async: false

      assert.equal result.state(), 'resolved'

    it 'should be configurable via $.ajaxSetup', ->

      $.ajaxSetup
        async: false

      result = $.ajax '/test'

      assert.equal result.state(), 'resolved'

  describe 'beforeSend', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: xhr.headers['some-header']
          contentType: 'text'

    it 'should allow manipulation of the request', (done) ->

      settings =
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader 'some-header', 'some header value'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, 'some header value'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should abort the request if it returns false', (done) ->

      settings =
        beforeSend: (xhr, settings) ->
          false

      $.ajax('/capture', settings).fail (xhr, textStatus, error) ->
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader 'some-header', 'some header value'

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.equal data, 'some header value'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'cache', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: xhr.url
          contentType: 'text'

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'POST'
        response: (data, xhr) ->
          responseText: xhr.url
          contentType: 'text'

    it 'should add a timestamp to the URL when false', (done) ->

      settings =
        cache: false

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.match data, /\_\=/ # /capture?_=[timestamp]
        done()

    it 'should not add a timestamp to the URL when true', (done) ->

      settings =
        cache: true

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, '/capture'
        done()

    it 'should be true by default', (done) ->

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.equal data, '/capture'
        done()

    it 'should not add a timestamp to the URL when false on a POST', (done) ->

      settings =
        cache: false
        method: 'POST'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, '/capture'
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        cache: false

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.match data, /\_\=/ # /capture?_=[timestamp]
        done()

  describe 'complete', ->

    it 'should call a "complete" handler on success', (done) ->

      $.ajax '/test',
        complete: (xhr, textStatus) ->
          assert.equal textStatus, 'success'
          done()

    it 'should call a "complete" handler on failure', (done) ->

      $.ajax '/error',
        complete: (xhr, textStatus) ->
          assert.equal textStatus, 'error'
          done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        complete: (xhr, textStatus) ->
          assert.equal textStatus, 'success'
          done()

      $.ajax '/test'

  describe 'contents', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify { test: 'this' }
          contentType: 'fakeson'

    it 'should allow custom contents handling', (done) ->

      settings =
        contents:
          json: /json|fakeson/

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.deepEqual data, { test: 'this' }
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        contents:
          json: /json|fakeson/

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.deepEqual data, { test: 'this' }
        done()

  describe 'contentType', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'POST'
        response: (data, xhr) ->
          responseText: xhr?.headers['Content-Type']
          contentType: 'text'

    it 'should be settable', (done) ->

      settings =
        method: 'POST'
        contentType: 'test-content-type'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, 'test-content-type'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it "should default to 'application/x-www-form-urlencoded; charset=UTF-8'", (done) ->

      settings =
        method: 'POST'
        data:
          test: 'this'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, 'application/x-www-form-urlencoded; charset=UTF-8'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup but not set up unless data is present', (done) ->

      $.ajaxSetup
        contentType: 'test-global-content-type'

      settings =
        method: 'POST'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, undefined
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup when data is present', (done) ->

      $.ajaxSetup
        contentType: 'test-global-content-type'

      settings =
        method: 'POST'
        data:
          test: 'this'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, 'test-global-content-type'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'context', ->

    it 'should be the settings by default', (done) ->

      settings =
        someSetting: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @someSetting, 'someVal'
        done()

    it 'should be made the context of callbacks', (done) ->

      settings =
        context:
          someKey: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @someKey, 'someVal'
        done()

    it 'should apply to beforeSend', (done) ->

      settings =
        context:
          someSetting: 'someVal'
        beforeSend: ->
          assert.equal @someSetting, 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        context:
          someKey: 'someVal'

      $.ajax('/test').done (data, textStatus, xhr) ->
        assert.equal @someKey, 'someVal'
        done()

  describe 'converters', ->

    it 'should add the converter while preserving the existing converters', (done) ->

      settings =
        converters:
          '* custom': ->

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.ok @converters['* custom']
        assert.ok @converters['* text']
        done()

    it 'be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        converters:
          '* custom': ->

      $.ajax('/test').done (data, textStatus, xhr) ->
        assert.ok @converters['* custom']
        assert.ok @converters['* text']
        done()

  describe 'data', ->

    it 'should add the data to the query string', (done) ->

      settings =
        data:
          someKey: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey=someVal'
        done()

    it 'should add a data array to the query string', (done) ->

      settings =
        data:
          someKey: ['1', '2', '3']

      # ?someKey[]=1&someKey[]=2&someKey[]=3
      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey%5B%5D=1&someKey%5B%5D=2&someKey%5B%5D=3'
        done()

    it 'should be configurable via $.ajaxSetup (and merged with data passed in settings', (done) ->

      $.ajaxSetup
        data:
          someOtherKey: 'someOtherValue'

      settings =
        data:
          someKey: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someOtherKey=someOtherValue&someKey=someVal'
        done()

  describe 'dataFilter', ->

    it 'should process the response data', (done) ->

      settings =
        dataType: 'json'
        dataFilter: (data, dataType) ->
          assert.equal dataType, 'json'
          data.replace /a\stest/, 'reformatted'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal data.test, 'This is reformatted'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        dataFilter: (data, dataType) ->
          assert.equal dataType, 'json'
          data.replace /a\stest/, 'reformatted'

      settings =
        dataType: 'json'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal data.test, 'This is reformatted'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'dataType', ->

    it 'should process the response data according to the dataType (json)', (done) ->

      settings =
        dataType: 'json'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal data.test, 'This is a test'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should process the response data according to the dataType (text)', (done) ->

      settings =
        dataType: 'text'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal data, JSON.stringify test: 'This is a test'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should infer the dataType based on the contentType (text)', (done) ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify { test: 'this' }
          contentType: 'text/plain'

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.equal data, JSON.stringify test: 'this'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should infer the dataType based on the contentType (json)', (done) ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify { test: 'this' }
          contentType: 'application/json'

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.equal data.test, 'this'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        dataType: 'json'

      $.ajax('/test').done (data, textStatus, xhr) ->
        assert.equal data.test, 'This is a test'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'error', ->

    it 'should accept an error callback', (done) ->

      settings =
        someSetting: 'someValue'
        error: (xhr, textStatus, error) ->
          assert.ok xhr
          assert.equal error, 'Internal Server Error'
          assert.equal textStatus, 'error'
          assert.ok @someSetting, 'someValue' # Check context to callback
          done()

      $.ajax '/error', settings

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        error: (xhr, textStatus, error) ->
          assert.ok xhr
          assert.equal error, 'Internal Server Error'
          assert.equal textStatus, 'error'
          assert.ok @someSetting, 'someValue' # Check context to callback
          done()

      settings =
        someSetting: 'someValue'

      $.ajax '/error', settings

  describe 'headers', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify
            'some-header': xhr.headers['some-header']
            'some-other-header': xhr.headers['some-other-header']
          contentType: 'json'

    it 'should add request headers and come before beforeSend', (done) ->

      settings =
        headers:
          'some-other-header': 'some other header value'
          'some-header': 'should be overwritten'
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader 'some-header', 'some header value'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data['some-header'], 'some header value'
        assert.equal data['some-other-header'], 'some other header value'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        headers:
          'some-other-header': 'some other header value'
          'some-header': 'should be overwritten'

      settings =
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader 'some-header', 'some header value'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data['some-header'], 'some header value'
        assert.equal data['some-other-header'], 'some other header value'
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'ifModified', ->

    it 'should allow checking of last modified header', (done) ->

      lastModified = Date.now()

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: ->
          responseText: JSON.stringify(test: 'this')
          headers:
            "Last-Modified": lastModified

      settings =
        ifModified: true

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->

        assert.ok xhr.getResponseHeader 'Last-Modified'

        $.ajax('/capture', settings).done (data, textStatus, xhr) ->
          assert.equal xhr.status, 304
          assert.equal textStatus, 'notmodified'
          done()
        .fail (xhr, textStatus, error) ->
          throw error

      .fail (xhr, textStatus, error) ->
        throw error

    it 'should allow checking of etag', (done) ->

      lastModified = Date.now()

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: ->
          responseText: JSON.stringify(test: 'this')
          headers:
            "etag": 'some-etag'

      settings =
        ifModified: true

      $.ajax('/capture?1', settings).done (data, textStatus, xhr) ->

        assert.ok xhr.getResponseHeader 'etag'

        $.ajax('/capture?1', settings).done (data, textStatus, xhr) ->
          assert.equal xhr.status, 304
          assert.equal textStatus, 'notmodified'
          done()
        .fail (xhr, textStatus, error) ->
          throw error

      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      lastModified = Date.now()

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: ->
          responseText: JSON.stringify(test: 'this')
          headers:
            "Last-Modified": lastModified

      $.ajaxSetup
        ifModified: true

      $.ajax('/capture').done (data, textStatus, xhr) ->

        assert.ok xhr.getResponseHeader 'Last-Modified'

        $.ajax('/capture').done (data, textStatus, xhr) ->
          assert.equal xhr.status, 304
          assert.equal textStatus, 'notmodified'
          done()
        .fail (xhr, textStatus, error) ->
          throw error

      .fail (xhr, textStatus, error) ->
        throw error

  describe 'mimeType', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify { test: 'this' }
          contentType: 'text/plain'

    it 'should override the xhr mime type', (done) ->

      settings =
        mimeType: 'application/json'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.deepEqual data, { test: 'this' }
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        mimeType: 'application/json'

      $.ajax('/capture').done (data, textStatus, xhr) ->
        assert.deepEqual data, { test: 'this' }
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'processData', ->

    it 'should default to true', (done) ->

      $.ajax('/test').done ->
        assert.isTrue @processData
        done()

    it 'should not serialize the data added to the query string if false', (done) ->

      settings =
        processData: false
        data: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someVal'
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        processData: false

      settings =
        data: 'someVal'

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someVal'
        done()

  describe 'statusCode', ->

    it 'should behave like a success callback when the request is successful', (done) ->

      settings =
        statusCode:
          200: (data, textStatus, xhr) ->
            assert.deepEqual data, { test: 'This is a test' }
            done()

      $.ajax '/test', settings

    it 'should behave like an error callback when the request is unsuccessful', (done) ->

      settings =
        statusCode:
          500: (xhr, textStatus, error) ->
            assert.equal error, 'Internal Server Error'
            done()

      $.ajax '/error', settings

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        statusCode:
          200: (data, textStatus, xhr) ->
            assert.deepEqual data, { test: 'This is a test' }
            done()

      $.ajax '/test'

  describe 'success', ->

    it 'should allow an array of functions and call each in turn', (done) ->

      handled = 0

      settings =
        success: [
          (data, textStatus, xhr) ->
            handled++
        ,
          (data, textStatus, xhr) ->
            handled++
        ,
          (data, textStatus, xhr) ->
            done() if handled is 2
        ]

      $.ajax '/test', settings

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        success: -> done()

      $.ajax '/test'

  describe 'timeout', ->

    beforeEach ->

      @delay = Ti.Network.HTTPClient.options.wait

      Ti.Network.HTTPClient.options.wait = 60

    afterEach ->
      Ti.Network.HTTPClient.options.wait = @delay

    it 'should throw an error on timeout', (done) ->

      settings =
        timeout: 50

      $.ajax('/test', settings).fail ->
        done()

    it 'should not throw an error if the response occurs within the timeout', (done) ->

      settings =
        timeout: 70

      $.ajax('/test', settings).done ->
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        timeout: 50

      $.ajax('/test').fail ->
        done()

  describe 'traditional', ->

    it 'should add array param when false', (done) ->

      settings =
        traditional: false
        data:
          someKey: ['1', '2', '3']

      # ?someKey[]=1&someKey[]=2&someKey[]=3
      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey%5B%5D=1&someKey%5B%5D=2&someKey%5B%5D=3'
        done()

    it 'should default to false', (done) ->

      settings =
        data:
          someKey: ['1', '2', '3']

      # ?someKey[]=1&someKey[]=2&someKey[]=3
      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey%5B%5D=1&someKey%5B%5D=2&someKey%5B%5D=3'
        done()

    it 'should not add array param when true', (done) ->

      settings =
        traditional: true
        data:
          someKey: ['1', '2', '3']

      # ?someKey=1&someKey=2&someKey=3
      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey=1&someKey=2&someKey=3'
        done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        traditional: true

      settings =
        data:
          someKey: ['1', '2', '3']

      # ?someKey=1&someKey=2&someKey=3
      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.equal @url, '/test?someKey=1&someKey=2&someKey=3'
        done()

  describe 'type and method', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'POST'
        response: (data, xhr) ->
          responseText: xhr?.headers['Content-Type']
          contentType: 'text'

    it 'should call the request using the specified type', (done) ->

      settings =
        type: 'POST'

      $.ajax('/capture', settings).done -> done()

    it 'should call the request using the specified method', (done) ->

      settings =
        method: 'POST'

      $.ajax('/capture', settings).done -> done()

    it 'should be "GET" by default', (done) ->

      $.ajax('/test').done -> done()

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        method: 'POST'

      $.ajax('/capture').done -> done()

  describe 'url', ->

    it 'should allow the url to be passed in as a setting', (done) ->

      settings =
        url: '/test'

      $.ajax(settings).done -> done()

    it 'should give precedence to the url passed in the first parameter', (done) ->

      settings =
        url: '/nope'

      $.ajax('/test', settings).done -> done()

    it 'should be configurable via $.ajaxSetup (for some reason)', (done) ->

      $.ajaxSetup
        url: '/test'

      $.ajax().done -> done()

  describe 'xhrFields', ->

    it 'should set fields on the HTTPClient', (done) ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: xhr?.autoEncodeUrl
          contentType: 'text'

      settings =
        xhrFields:
          autoEncodeUrl: false

      $.ajax('/capture', settings).done (data) ->
        assert.equal data, false
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: [xhr?.autoEncodeUrl, xhr?.tlsVersion].join ':'
          contentType: 'text'

      $.ajaxSetup
        xhrFields:
          tlsVersion: 3

      settings =
        xhrFields:
          autoEncodeUrl: false

      $.ajax('/capture', settings).done (data) ->
        assert.equal data, "false:3"
        done()
      .fail (xhr, textStatus, error) ->
        throw error

  describe 'username and password', ->

    beforeEach ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: [xhr.username, xhr.password].join ':'
          contentType: 'text'

    it 'should set fields on the HTTPClient', (done) ->

      settings =
        username: 'someUsername'
        password: 'somePassword'

      $.ajax('/capture', settings).done (data) ->
        assert.equal data, "someUsername:somePassword"
        done()
      .fail (xhr, textStatus, error) ->
        throw error

    it 'should be configurable via $.ajaxSetup', (done) ->

      $.ajaxSetup
        username: 'someUsername'
        password: 'somePassword'

      $.ajax('/capture').done (data) ->
        assert.equal data, "someUsername:somePassword"
        done()
      .fail (xhr, textStatus, error) ->
        throw error
