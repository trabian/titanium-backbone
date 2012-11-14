environment = require 'environment'

module.exports =

  deviceStyles: (styles) ->

    mergedStyles = _({}).extend styles.default or {}

    for device in ['ios', 'android']
      if (deviceStyles = styles[device]) and environment[device]
        _(mergedStyles).extend deviceStyles

    mergedStyles
