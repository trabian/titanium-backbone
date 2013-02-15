module.exports =

  button: require './button'
  contentBlock: require './content_block'
  form: require './form'
  labels: require './labels'
  search: require './search'
  tabbedBar: require './tabbed_bar'
  table: require './table'
  window: require './window'
  elements: require './elements'

  activity:
    style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
    top: 11
    left: 11
    height:Ti.UI.SIZE
    width:Ti.UI.SIZE
    font:
      fontSize: 15
      fontWeight: 'bold'
