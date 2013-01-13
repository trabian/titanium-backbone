nonContainers = [
  "ActivityIndicator"
  "Button"
  "ImageView"
  "Label"
  "ProgressBar"
  "SearchBar"
  "Slider"
  "Switch"
  "TextArea"
  "TextField"
  "WebView"
]

defaultHandler =

  add: (parent, child) ->
    parent.add child

  remove: (parent, child) ->
    parent.remove child

barHandler =

  add: (parent, child) ->
    throw new Error "The children of #{parent._viewName} views are added via the 'labels' array."

  remove: (parent, child) ->
    throw new Error "The children of #{parent._viewName} views are added via the 'labels' array."

toolbarHandler =

  add: (parent, child) ->
    throw new Error "The children of #{parent._viewName} views are added via the 'items' array."

  remove: (parent, child) ->
    throw new Error "The children of #{parent._viewName} views are added via the 'items' array."

viewHandlers =

  ButtonBar: barHandler

  TabbedBar: barHandler

  "iOS::TabbedBar": barHandler

  TableView:

    add: (parent, child) ->
      switch child._viewName
        when 'TableViewRow'
          parent.appendRow child
        when 'TableViewSection'
          parent.appendSection child
        else
          throw new Error "TableView views can only serve as containers for TableViewRow and TableViewSection views"

    remove: (parent, child) ->

      switch child._viewName
        when 'TableViewRow'
          parent.deleteRow _.indexOf parent.rows, child
        when 'TableViewSection'
          parent.deleteSection _.indexOf parent.sections, child
        else
          throw new Error "TableView views can only serve as containers for TableViewRow and TableViewSection views"

  TableViewSection:

    add: (parent, child) ->
      if child._viewName is 'TableViewRow'
        parent.add child
      else
        throw new Error "TableViewSection views can only serve as containers for TableViewRow views"

    remove: (parent, child) ->

      # According to the Titanium API documentation, to remove a row from a
      # section after the table is rendered, use the TableView deleteRow
      # method.
      if child._viewName is 'TableViewRow'
        table = parent.parent
        table.deleteRow _.indexOf table.rows, child
      else
        throw new Error "TableViewSection views can only serve as containers for TableViewRow views"

  Picker:

    add: (parent, child) ->
      if child._viewName in ['PickerRow', 'PickerColumn']
        parent.add child
      else
        throw new Error "Picker views can only serve as containers for PickerRow and PickerColumn views"

    remove: (parent, child) ->

      if child._viewName is 'PickerColumn'
        parent.setColumns _.without parent.columns, child
      else
        throw new Error "Pickers can not directly remove PickerRows or other view types"

  PickerColumn:

    add: (parent, child) ->
      if child._viewName is 'PickerRow'
        parent.addRow child
      else
        throw new Error "PickerColumn views can only serve as containers for PickerRow views"

    remove: (parent, child) ->
      if child._viewName is 'PickerRow'
        console.warn 'remove row', child
        parent.removeRow child
      else
        throw new Error "PickerColumn views can only serve as containers for PickerRow views"

  Toolbar: toolbarHandler

  "iOS::Toolbar": toolbarHandler

for container in nonContainers

  viewHandlers[container] =

    add: (parent, child) ->
      throw new Error "#{parent._viewName} views can not serve as containers for other views"

    remove: (parent, child) ->
      throw new Error "#{parent._viewName} views can not serve as containers for other views"

module.exports =

  handle: (command, parent, child) ->

    # If a PickerRow is added directly to a Picker then a single PickerColumn
    # will be created by Titanium to hold it and any other rows. This created
    # PickerColumn will not have a _viewName attribute so we need to handle
    # removal of PickerRows based on child._viewName rather than
    # parent._viewName.
    if (child._viewName is 'PickerRow') and command is 'remove'
      parent.removeRow child

    else

      handlerCommand = viewHandlers[parent._viewName]?[command] or defaultHandler[command]
      handlerCommand parent, child

