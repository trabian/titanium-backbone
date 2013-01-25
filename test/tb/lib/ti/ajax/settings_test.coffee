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

  describe 'accepts', ->

    it 'should set the Accept request header', (done) ->

      settings =
        accepts:
          'custom': 'custom-request-type'
        dataType: 'custom text'
        converters:
          "* custom": _.identity

      $.ajax('/test', settings).done (data, textStatus, xhr) ->
        assert.match xhr.getRequestHeader('Accept'), /custom-request-type/
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

      $.ajax('/test', settings).always (data, textStatus, xhr) ->
        assert.match xhr.getRequestHeader('Accept'), /text\/plain/
        done()

    it 'should default to */*', (done) ->

      $.ajax('/test').always (data, textStatus, xhr) ->
        assert.equal xhr.getRequestHeader('Accept'), '*/*'
        done()

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
  describe 'contents', ->
  describe 'contentType', ->
  describe 'context', ->
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
