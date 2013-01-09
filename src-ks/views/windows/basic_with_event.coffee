module.exports = class Window extends Backbone.View

  viewName: 'Window'

  attributes:
    backgroundColor: '#090'

  events:
    open: 'open'
    otherEvent: 'otherEvent'

  open: ->

    @$el.trigger 'otherEvent',
      message: 'Hello World'

  otherEvent: (e) ->
    alert e.message
