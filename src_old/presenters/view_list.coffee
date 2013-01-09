ViewPresenter = require './view'

module.exports = class ViewPresenterList extends Backbone.Collection

  model: ViewPresenter

  # These aren't pulled from a server, so just trigger the 'success' callback
  # and fire the 'reset' event.
  fetch: (options = {}) =>
    @trigger 'reset'
    options.success? @

  selectOne: (selected) =>

    @each (presenter) ->
      presenter.set
        selected: presenter is selected

    @trigger 'select', selected
