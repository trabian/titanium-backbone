colors = require('styles/theme').colors
labels = require('styles/ui/labels')
helpers = require 'styles/helpers'

title = _.extend labels.label(14, font: { fontWeight: 'bold' }),
  bottom: 4
  left: 7

module.exports =

  view:
    layout: 'vertical'
    height: Ti.UI.SIZE

  fieldList:
    view:
      height: Ti.UI.SIZE
      layout: 'vertical'
    field:
      view:
        height: Ti.UI.SIZE
        layout: 'vertical'
      title: title

  table:

    view:
      borderColor: colors.table.border
      borderRadius: 11
      scrollable: false
      bottom: 11
      height: Ti.UI.SIZE

    row:
      view:
        helpers.deviceStyles
          default:
            height: 44
          ios:
            selectionStyle: Ti.UI.iPhone.TableViewCellSelectionStyle.NONE
      editor:
        width: '60%'
        right: 0
      label:
        view:
          left: 13
          width: '40%'
        label:
          primary:
            height: 19
            color: colors.form.label
            font:
              fontWeight: 'bold'
              fontSize: 14

  editors: require './editors'

  window: require './window'
