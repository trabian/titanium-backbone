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
      helpers.deviceStyles
        default:
          borderColor: colors.table.border
          scrollable: false
          height: Ti.UI.SIZE
          separatorColor: colors.table.border
        ios:
          borderRadius: 11
        android:
          borderWidth: 1
          backgroundColor: '#fff'
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
                left: 0
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
              default:
                left: 0
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
                right: 0
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
                right: 0
                textAlign: 'right'
              ios:
                height: 15
              android:
                wordWrap: false
