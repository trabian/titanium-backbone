helpers = require '../../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'

$ = ti.$
Ti = ti.Ti

describe '$.ajax methods', ->

  afterEach ->
    Ti.Network.HTTPClient.resetMock()

  it 'should exist', ->
    assert.ok $.ajax

  describe 'a simple GET request', ->

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
      ], wait: 100

    describe 'success and error handlers', ->

      it 'should return a status and responseText on success', (done) ->

        $.ajax '/test',
          success: (data, textStatus, xhr) ->
            assert.ok xhr.responseText
            assert.equal xhr.status, 200
            done()

      it 'should return a status and responseText on error', (done) ->

        $.ajax '/error',
          error: (data, textStatus, xhr) ->
            assert.ok xhr.responseText
            assert.equal xhr.status, 500
            done()

    it 'should format text data', (done) ->

      $.ajax '/test',
        success: (data, textStatus, xhr) ->
          assert.equal data, JSON.stringify test: 'This is a test'
          done()

    it 'should format JSON data', (done) ->

      $.ajax '/test',
        dataType: 'json'
        success: (data, textStatus, xhr) ->
          assert.equal data.test, 'This is a test'
          done()

    it 'should support "done" deferreds', (done) ->

      $.ajax('/test').done (data, textStatus, xhr) ->
        assert.equal data, JSON.stringify test: 'This is a test'
        done()

    it 'should support "fail" deferreds', (done) ->

      $.ajax('/error').fail (data, textStatus, xhr) ->
        assert.equal xhr.status, 500
        done()

  describe 'a simple POST request', ->

    beforeEach ->

      Ti.Network.HTTPClient.mock [
        url: '/test'
        method: 'POST'
        response: (data) ->
          status: 200
          responseText:
            JSON.stringify
              wrapped: data
      ,
        url: '/test/nodata'
        method: 'POST'
        response:
          status: 200
      ], wait: 100

    it 'should pass data to the request', (done) ->

      postedData =
        someKey: 1
        otherKey: 'some data'

      $.ajax '/test',
        type: 'POST'
        dataType: 'json'
        data: postedData
      .done (data, textStatus, xhr) ->
        assert.equal JSON.stringify(data), JSON.stringify(wrapped: postedData)
        done()

    it 'should support POSTs without data', (done) ->

      $.ajax '/test',
        type: 'POST'
      .done (data, textStatus, xhr) ->
        assert.equal xhr.status, 200
        done()
