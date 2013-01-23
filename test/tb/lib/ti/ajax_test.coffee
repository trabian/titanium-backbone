helpers = require '../../../helpers'
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

  describe 'a simple request', ->

    beforeEach ->

      Ti.Network.HTTPClient.mock [
        url: '/test'
        method: 'GET'
        response:
          status: 200
          responseText:
            JSON.stringify
              test: 'This is a test'

      ],
        wait: 100

    it 'should return a status and responseText', (done) ->

      $.ajax '/test',
        success: (data, textStatus, xhr) ->
          assert.ok xhr.responseText
          assert.equal xhr.status, 200
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

    it 'should support deferreds', (done) ->

      $.ajax('/test').done (data, textStatus, xhr) ->
        assert.equal data, JSON.stringify test: 'This is a test'
        done()

    user = new User

    user.fetch()

    getAccount = ->
      user.pipe ->
        account = user.get('accounts').first()
        account

    account = new Account

    model.fetch()

    view = new View
      deferred: getAccount

    render: ->

      @$el.html '<Label>Loading...</Label>'

      @options.deferred.done ->
        @$el.html '<Label>Loaded.</Label>'

      @

