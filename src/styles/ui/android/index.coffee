labels = require 'styles/ui/labels'

module.exports =

  actionBar:

    view:
      top: 0
      height: 45
      backgroundColor: '#333'

    title:
      labels.heading 17,
        color: '#fff'
        top: null
        bottom: null
        left: 10
        right: 50
        ellipsize: true
        wordWrap: false
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
