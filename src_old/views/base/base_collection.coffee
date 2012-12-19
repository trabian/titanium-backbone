View = require './index'

module.exports = class CollectionView extends View

  initialize: ->

    super

    if @options.items
      ViewList = require 'presenters/view_list'
      @collection ?= new ViewList @options.items

    _(@options).defaults
      fetchOnInit: true

    @modelBind 'reset', @addAll
    @modelBind 'add', @addOne

    if @options.fetchOnInit
      @collection.fetch()

  addAll: =>

    @collection.each (model, index) =>
      @addOne model, { index }

  addOne: ->
