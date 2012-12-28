module.exports = ($) ->

  add: (child) ->
    @[0].add child
    $ child

  remove: ->

    if parent = @parent()
      @each ->
        unless @_removed
          parent[0].remove @
          @_removed = true

  empty: ->

    # Removing the children can take a moment and lead to 'jumpiness' in the
    # UI as some elements are removed from the view immediately while others
    # take a bit longer. Hiding the view before removing its children and
    # then showing it again afterwards removes the jumpiness.
    @hide()

    @each (el) ->
      el.remove child for child in el.children

    @show()

  hide: ->
    @each (el) -> el.hide()

  show: ->
    @each (el) -> el.show()
