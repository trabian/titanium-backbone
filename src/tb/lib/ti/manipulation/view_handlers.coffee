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

viewHandlers =

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
      switch child._viewName
        when 'TableViewRow'
          table = parent.parent
          table.deleteRow _.indexOf table.rows, child
        else
          throw new Error "TableViewSection views can only serve as containers for TableViewRow views"


for container in nonContainers

  viewHandlers[container] =

    add: (parent, child) ->
      throw new Error "#{parent._viewName} views can not serve as containers for other views"

    remove: (parent, child) ->
      throw new Error "#{parent._viewName} views can not serve as containers for other views"

module.exports =

  handle: (command, parent, child) ->
    handler = viewHandlers[parent._viewName]?[command] or defaultHandler[command]
    handler parent, child

