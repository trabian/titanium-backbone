colors = require('styles/theme').colors

module.exports =

  view:
    layout: 'vertical'
    height: Ti.UI.SIZE

  fieldList:
    view:
      height: Ti.UI.SIZE
      layout: 'vertical'

  table:

    view:
      borderColor: colors.table.border
      borderRadius: 11
      scrollable: false
      bottom: 11

    row:
      view:
        selectionStyle: Ti.UI.iPhone.TableViewCellSelectionStyle.NONE
        height: 44
      editor:
        width: '60%'
        right: 0
      label:
        view:
          left: 11
          width: '40%'
        label:
          primary:
            height: 19
            color: colors.form.label
            font:
              fontWeight: 'bold'
              fontSize: 17

  editors: require './editors'

  window: require './window'
