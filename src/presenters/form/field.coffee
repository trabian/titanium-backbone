module.exports = class Field extends Backbone.Model

  initialize: (attrs) ->

    if currentModel = @collection.currentModel

      @set
        value: currentModel.get @get 'key'

      # Check the rest of the fields to see if this is the only one preventing it from validating.
      # This is useful in the mobile app to present a 'Done' return key.
      currentModel.on 'change', =>

        attributesToCheck = _.without _.keys(@collection.attributes()), @get 'key'

        @set lastInvalid: currentModel.isValid attributesToCheck

  defaults:
    as: 'string'
    section: 'default'

  hint: =>
    (@get 'hint') or ('Required' if @get 'required')
