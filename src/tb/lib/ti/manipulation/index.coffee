viewHandlers = require './view_handlers'

module.exports = ($) ->

  append: (child) ->

    parent = @[0]

    $(child).each ->
      viewHandlers.handle 'add', parent, $(@)[0]

    @

  appendTo: (parent) ->
    $(parent).append @[0]
    @

  remove: ->

    if parent = @parent()
      @each ->
        unless @_removed
          viewHandlers.handle 'remove', parent[0], @
          @_removed = true

    @

  empty: ->

    removeChildren = (el) ->
      el.remove child for child in el.children

    # Removing the children can take a moment and lead to 'jumpiness' in the
    # UI as some elements are removed from the view immediately while others
    # take a bit longer. Hiding the view before removing its children and
    # then showing it again afterwards removes the jumpiness.
    @hide()
      .each(removeChildren)
      .show()

  hide: ->
    @each (el) -> el.hide()

  show: ->
    @each (el) -> el.show()
