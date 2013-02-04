Chaplin = require 'chaplin'

module.exports = class Dispatcher extends Chaplin.Dispatcher

  executeAction: (controller, controllerName, action, params, options) ->

    if controller.layout

      if @currentLayout and @currentLayout isnt controller.layout
        @publishEvent "destroyLayout:#{@currentLayout}"

      @currentLayout = controller.layout

    @subscribeEvent "destroyLayout:#{@currentLayout}", ->
      controller.dispose()

    # Call the controller action with params and options
    controller[action] params, options

    # Stop if the action triggered a redirect
    return if controller.redirected

    # We're done! Spread the word!
    @publishEvent 'startupController',
      layout: @currentLayout
      controller: controller
      controllerName: controllerName
      params: params
      options: options
