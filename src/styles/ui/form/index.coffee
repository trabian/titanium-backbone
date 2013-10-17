colors = require('styles/theme').colors
labels = require('styles/ui/labels')
helpers = require 'styles/helpers'

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
      title:
        view:
          bottom: 4
          left: 14
        label:
          primary:
            font:
              fontSize: 14
              # fontWeight: 'bold'

  table:

    view:
      borderWidth: "1px"
      left: '-2px'
      right: '-2px'
      borderColor: colors.table.border
      scrollable: false
      top: 33
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
          left: 15
          width: '40%'
        label:
          primary:
            height: 19
            color: colors.form.label
            font:
              # fontWeight: 'bold'
              fontSize: 14

  editors: require './editors'

  window: require './window'
