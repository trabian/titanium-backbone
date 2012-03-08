module.exports =

  run: ->

    # Remove this once you're ready to create your own app.
    KitchenSinkIntroView = require 'ks/views/intro'

    introView = new KitchenSinkIntroView

    introView.render().open()
