colors = require('styles/theme').colors
labels = require 'styles/ui/labels'
helpers = require 'styles/helpers'

sectionLabel = _({}).extend labels.label(13),
  color: colors.table.sectionLabel
  left: 5
  top: 2
  bottom: 2
  height: 20

module.exports =

  section:
    view:
      height: 25
    header:
      view:
        height: 25
        backgroundColor: colors.table.sectionBackground
      title:
        view:
          top: 3
          left: 7
          width: '30%'
        label:
          primary:
            color: colors.table.sectionLabel
            height: 17
            font:
              fontSize: 13
          meta:
            color: colors.table.sectionLabel
            height: 13
            font:
              fontSize: 12
      subtitle:
        view:
          top: 3
          right: 7
          width: '60%'
        label:
          primary:
            color: colors.table.sectionLabel
            height: 17
            textAlign: 'right'
            font:
              fontSize: 13
          meta:
            color: colors.table.sectionLabel
            height: 13
            textAlign: 'right'
            font:
              fontSize: 12

  details:
    styled:
      borderColor: colors.table.border
      borderRadius: 11
      scrollable: false
      height: Ti.UI.SIZE
      separatorColor: colors.table.border
    plain:
      height: Ti.UI.FILL
      separatorColor: colors.table.border

    row:
      view:
        height: 44
        top: 0
      title:
        view:
          left: 11
          width: '60%'
        label:
          primary:
            helpers.deviceStyles
              default:
                font:
                  fontWeight: 'bold'
                  fontSize: 14
              android:
                wordWrap: false
                ellipsize: true
              ios:
                height: 17
          meta:
            helpers.deviceStyles
              ios:
                height: 15
              android:
                wordWrap: false
      subtitle:
        view:
          right: 11
          width: '40%'
        label:
          primary:
            helpers.deviceStyles
              default:
                textAlign: 'right'
                font:
                  fontWeight: 'bold'
                  fontSize: 14
              ios:
                height: 17
              android:
                wordWrap: false
                ellipsize: true
          meta:
            helpers.deviceStyles
              default:
                textAlign: 'right'
              ios:
                height: 15
              android:
                wordWrap: false
