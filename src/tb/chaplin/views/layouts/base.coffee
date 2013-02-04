EventBroker = require 'chaplin/lib/event_broker'

module.exports = class Layout

  # Borrow the static extend method from Backbone
  @extend = Backbone.Model.extend

  # Mixin an EventBroker
  _(@prototype).extend EventBroker

  showView: (view) -> view.el.open()
