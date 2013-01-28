helpers = require '../../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'

$ = ti.$
Ti = ti.Ti

describe '$.ajax settings', ->

  beforeEach ->

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

  describe 'async', ->

    it 'should default to true', (done) ->

      result = $.ajax('/test').always (data, textStatus, xhr) ->
        done()

      assert.equal result.state(), 'pending'

    it 'should be possible to set it to false', ->

      result = $.ajax '/test',
        async: false

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

      $.ajax('/capture', settings).fail (data, textStatus, xhr) ->
        done()

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

  describe 'contents', ->

    it 'should allow custom contents handling', (done) ->

      Ti.Network.HTTPClient.mocks.push
        url: '/capture'
        method: 'GET'
        response: (data, xhr) ->
          responseText: JSON.stringify { test: 'this' }
          contentType: 'fakeson'

      settings =
        contents:
          json: /json|fakeson/

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
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
      .fail (textStatus, xhr, error) ->
        throw error

    it "should default to 'application/x-www-form-urlencoded; charset=UTF-8'", (done) ->

      settings =
        method: 'POST'
        data:
          test: 'this'

      $.ajax('/capture', settings).done (data, textStatus, xhr) ->
        assert.equal data, 'application/x-www-form-urlencoded; charset=UTF-8'
        done()
      .fail (textStatus, xhr, error) ->
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

  describe 'converters', ->
  describe 'data', ->
  describe 'dataFilter', ->
  describe 'dataType', ->
  describe 'error', ->
  describe 'global', ->
  describe 'headers', ->
  describe 'ifModified', ->
  describe 'processData', ->
  describe 'statusCode', ->
  describe 'success', ->
  describe 'timeout', ->
  describe 'type', ->
  describe 'url', ->
  describe 'xhrFields', ->
