helpers = require '../../helpers'

{ assert } = helpers.chai

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

    # assert.equal (new ViewWithoutAutoRender).$el.find('Label').length, 0

    # assert.equal (new ViewWithAutoRender).$el.find('Label').length, 1
