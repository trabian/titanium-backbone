module.exports =

  # Public: If a value is a function, call that function. Otherwise, return the value.
  #
  # Examples
  #
  #   class Label extends View
  #
  #     # Attributes as a function:
  #     attributes: ->
  #       text: "This label has an id of #{@id}."
  #
  #     # Attributes an object:
  #     attributes:
  #       text: 'This is a static label'
  #
  getValue: (object, prop) ->
    if val = object?[prop]
      if _.isFunction(val) then val() else val
    else
      null
