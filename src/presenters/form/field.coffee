module.exports = class Field extends Backbone.Model

  initialize: (attrs) ->

    @set
      value: @collection.currentModel.get @get 'key'

  defaults:
    as: 'string'
    section: 'default'

  hint: =>
    (@get 'hint') or ('Required' if @get 'required')
