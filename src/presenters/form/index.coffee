FieldList = require './field_list'

module.exports = class Form extends Backbone.Model

  defaults:
    saveable: false
    updateOnly: false
    sections: [
      { key: 'default', group: true }
      { key: 'none', group: false }
    ]

  initialize: (attributes) ->

    @original = attributes?.model

    @buildClone()

    @buildFields attributes

  buildClone: =>

    @clone = @original.clone()

    @clone.on 'change', =>

      @set
        saveable: ! @clone.validate @fields.attributes()

  buildFields: (attributes) =>

    @fields = new FieldList

    @fields.currentModel = @clone

    @fields.add attributes?.fields

    @fields.on 'change', (field) =>

      # Set silently to prevent validation on the clone
      @clone.set (field.get 'key'), (field.get 'value'), silent: true

      # Trigger the change event since we were silent
      @clone.change()

  save: =>

    if @get 'updateOnly'
      @original.set @fields.attributes()
    else
      @original.save @fields.attributes()
