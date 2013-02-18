helpers = require '../../helpers'

{ assert } = helpers.chai
sinon = helpers.sinon

_ = require 'underscore'

Backbone = helpers.require 'backbone'
Chaplin = helpers.require 'chaplin'

CollectionView = helpers.require 'tb/views/collection'

describe 'Collection view', ->

  it 'should support support adding collection items', ->

    class Row extends Chaplin.View

      tagName: 'TableViewRow'

      className: -> @model.get 'name'

      render: ->
        @$el.html '<Label>'
        @

    class Table extends CollectionView

      tagName: 'TableView'

      autoRender: true

      itemView: Row

    collection = new Backbone.Collection [
      id: _.uniqueId 'row'
      name: 'test-1'
    ,
      id: _.uniqueId 'row'
      name: 'test-2'
    ]

    table = new Table { collection }

    assert.equal table.$el.find('TableViewRow').length, 2

  it 'should resize a ScrollView if present when adding items', ->

    class Row extends Chaplin.View

      tagName: 'TableViewRow'

      className: -> @model.get 'name'

      render: ->
        @$el.html '<Label>'
        @

    class Table extends CollectionView

      tagName: 'TableView'

      autoRender: true

      itemView: Row

    class ScrollView extends Chaplin.View

      tagName: 'ScrollView'

    collection = new Backbone.Collection()

    table = new Table { collection }

    scrollView = new ScrollView

    spy = sinon.spy();

    scrollView.$el.append table.el

    scrollView.el.applyProperties = spy

    collection.add
      id: _.uniqueId 'row'
      name: 'test-3'

    assert spy.called
