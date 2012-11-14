styles = require('styles').ui.labels.combined

View = require 'views/base'

# Creates a 'View' instead of a 'Label' to allow for subtitles.
module.exports = class Label extends View

  attributes: styles.view

  render: =>

    @options.label ?= @options.text

    { primary, meta } = @extractLabels @options.label

    @view.add @primary = @make 'Label', styles.primary, @options.labelStyle?.primary,
      text: "#{primary}"

    if meta

      @view.add @meta = @make 'Label', styles.meta, @options.labelStyle?.meta,
        text: "#{meta}"

    @

  extractLabels: (label) ->

    if _.isString(label)
      primary: label
    else
      primary: label.primary
      meta: label.meta
