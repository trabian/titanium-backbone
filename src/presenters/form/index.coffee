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

    if fields = attributes.fields
      @set { fields }

    @buildFields()

  buildClone: =>

    @clone = @original.clone()

    @clone.on 'change', =>

      # Check the fields handled by this form to determine if they are valid
      @set
        saveable: (! @clone.validate?) or @clone.isValid _.keys @fields.attributes()

  buildFields: =>

    @fields = new FieldList

    @fields.form = @

    @fields.currentModel = @clone

    @fields.add @get 'fields'

    @fields.on 'change', (field) =>

      # Set silently to prevent validation on the clone
      @clone.set (field.get 'key'), (field.get 'value'), silent: true

      # Trigger the change event since we were silent
      @clone.change()

    @fields.on 'save', =>

      if @clone.isValid(true)
        @save()

  save: =>

    if @get 'updateOnly'
      @original.set @fields.attributes()
    else
      @original.save @fields.attributes()
