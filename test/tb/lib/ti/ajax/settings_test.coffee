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

      $.ajax('/test', settings).always (data, textStatus, xhr) ->
        assert.match xhr.headers['Accept'], /custom-request-type/
        done()

    it 'should not overwrite existing request headers', (done) ->

      settings =
        accepts:
          custom: 'custom-request-type'
        dataType: 'text'

      $.ajax('/test', settings).always (data, textStatus, xhr) ->
        assert.match xhr.headers['Accept'], /text\/plain/
        done()

    it 'should default to */*', (done) ->

      $.ajax('/test').always (data, textStatus, xhr) ->
        assert.equal xhr.headers['Accept'], "*/*"
        done()

  describe 'async', ->
  describe 'beforeSend', ->
  describe 'cache', ->
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
