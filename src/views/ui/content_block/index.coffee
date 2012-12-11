styles = require('styles').ui
viewStyles = styles.contentBlock

View = require 'views/base'

template = require './template'

module.exports = class ContentBlock extends View

  attributes: styles.contentBlock.view

  render: =>

    if text = @options.text

      @view.add @make 'Label', viewStyles.text,
        text: @options.text

    else

      @view.add @make 'WebView', viewStyles.html,
        willHandleTouches: false
        html: template
          title: 'Content Block'
          text: @options.html

    @
