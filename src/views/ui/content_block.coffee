styles = require('styles').ui

View = require 'views/base'

module.exports = class ContentBlock extends View

  attributes: styles.contentBlock.view

  render: =>

    @view.add @make 'Label', styles.labels.p, styles.contentBlock.text,
      text: @options.text

    @
