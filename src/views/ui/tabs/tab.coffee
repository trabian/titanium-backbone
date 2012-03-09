View = require 'views/base'

Window = require 'views/ui/window'

module.exports = class Tab extends View

  viewName: 'Tab'

  attributes: =>
    title: @presenter.get 'title'
    icon: "images/#{@presenter.get 'icon'}"
    window: @buildWindow()

  buildWindow: =>
    
    window = new (@presenter.get 'viewClass')
      model: @model
      style:
        title: @presenter.get 'title'

    window.render().view
