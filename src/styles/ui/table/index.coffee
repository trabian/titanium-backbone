{ colors, fonts } = require 'styles/theme'
labels = require 'styles/ui/labels'

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
              fontFamily: fonts.base
          meta:
            color: colors.table.sectionLabel
            height: 13
            font:
              fontSize: 12
              fontFamily: fonts.base
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
              fontFamily: fonts.base
              fontSize: 13
          meta:
            color: colors.table.sectionLabel
            height: 13
            textAlign: 'right'
            font:
              fontSize: 12
              fontFamily: fonts.base

  details:
    styled:
      borderColor: colors.table.border
      borderRadius: 0
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
          left: 15
          width: '60%'
        label:
          primary:
            height: 19
            font:
              # fontWeight: 'bold'
              fontSize: 14
              fontFamily: fonts.base
          meta:
            height: 15
      subtitle:
        view:
          right: 11
          width: '40%'
        label:
          primary:
            height: 19
            textAlign: 'right'
            font:
              # fontWeight: 'bold'
              fontSize: 14
              fontFamily: fonts.base
          meta:
            height: 15
            textAlign: 'right'
