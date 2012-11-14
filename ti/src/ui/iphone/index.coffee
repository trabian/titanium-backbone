Ti.UI.iPhone =
  ActivityIndicatorStyle: { "DARK" }
  SystemButtonStyle: { "DONE" }
  TableViewCellSelectionStyle: 'table-view-cell-selection-style'

class TitaniumTabbedBar extends TitaniumView

Ti.UI.iOS =

  createTabbedBar: (attributes) ->
    new TitaniumTabbedBar attributes
