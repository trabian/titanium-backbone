ti = require 'tb/lib/ti'

Backbone.$ = ti.$

module.exports = class View extends Backbone.View

  # The default `viewName` for a View is `"View"`, which serves as
  # the base of all Titanium views.
  viewName: 'View'

  # Delegate tagName to viewName to reduce the number of Backbone.View
  # methods which need to be overridden
  tagName: -> _.result @, 'viewName'

  ###
    This overridden version of `make` will produce a Titanium view based on
    the provided `viewName` and `attributes`. The `attributes` can be supplied
    by multiple hashes which will be combined via `extend` to form a single
    hash, with attributes being overwritten from right to left.
  ###
  make: (viewName, attributeHashes...) ->

    attributes = _.extend {}, attributeHashes...

    Backbone.$("<#{viewName}>").attr attributes

  _configure: (options) ->

    # If attributes are provided in the constructure, merge them with
    # attributes provided by an 'attributes' attribute or function
    if options.attributes and attrs = _.extend {}, _.result(this, 'attributes')
      options.attributes = _.extend attrs, options.attributes

    super
