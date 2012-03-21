Field = require './field'

ViewList = require 'presenters/view_list'

module.exports = class FieldList extends ViewList

  model: Field

  attributes: =>
    @reduce (hash, field) ->
      hash[field.get 'key'] = field.get 'value'
      hash
    , {}
