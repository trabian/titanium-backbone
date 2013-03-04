environment = require 'environment'

module.exports =

  # Inline string editors add 10 px left padding on Android. This adjustment
  # aligns other fields with the text in a string editor.
  inlinePaddingAdjustment: 10

  deviceStyles: (styles) ->

    mergedStyles = _({}).extend styles.default or {}

    for device in ['ios', 'android']
      if (deviceStyles = styles[device]) and environment[device]
        _(mergedStyles).extend deviceStyles

    mergedStyles
