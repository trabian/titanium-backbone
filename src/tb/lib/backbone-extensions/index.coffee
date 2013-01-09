ti = require 'tb/lib/ti'

module.exports =

  load: ->

    Backbone.$ = ti.$

    @extendView()

  extendView: ->

    # The default `viewName` for a View is `"View"`, which serves as
    # the base of all Titanium views.
    Backbone.View::viewName = 'View'

    # Delegate tagName to viewName to reduce the number of Backbone.View
    # methods which need to be overridden
    Backbone.View::tagName = ->
      _.result @, 'viewName'

    _originalConfigure = Backbone.View::_configure

    Backbone.View::_configure = (options) ->

      # If attributes are provided in the constructor, merge them with
      # attributes provided by an 'attributes' attribute or function
      if options.attributes and attrs = _.extend {}, _.result(this, 'attributes')
        options.attributes = _.extend attrs, options.attributes

      _originalConfigure.call @, options
