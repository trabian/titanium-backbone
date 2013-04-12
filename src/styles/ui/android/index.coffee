labels = require 'styles/ui/labels'

theme = require('styles/theme')
colors = theme.colors

module.exports =

  actionBar:

    view:
      top: 0
      height: 45
      backgroundColor: colors.actionBar.background

    icon:
      left: 6
      top: 6
      height: 32
      width: 32
      image: theme.images?.actionBar.icon

    titleWrapper:
      left: 45
      right: 0

    title:
      labels.heading 17,
        color: colors.actionBar.text
        top: null
        bottom: null
        left: 0
        right: 0
        ellipsize: true
        # wordWrap: false # broken in 3.1.0 beta
        # height: 30

    actions:
      view:
        right: 0
        width: Ti.UI.SIZE
        height: Ti.UI.FILL
        layout: 'horizontal'

    action:
      view:
        height: Ti.UI.FILL
        width: Ti.UI.SIZE
      icon:
        width: 17
        height: 17
        left: 10
        right: 10
      label:
        labels.heading 12,
          top: null
          bottom: null
          color: '#fff'
          width: Ti.UI.SIZE
          left: 10
          right: 10
