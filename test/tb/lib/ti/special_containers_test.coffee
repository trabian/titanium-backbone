helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$.append and $.remove methods on special containers', ->

  it 'should throw an error on non-containers', ->

    for viewName in [
      "ActivityIndicator"
      "Button"
      "ButtonBar"
      "ImageView"
      "Label"
      "PickerColumn"
      "ProgressBar"
      "SearchBar"
      "Slider"
      "Switch"
      "TabbedBar"
      "iOS::TabbedBar"
      "TextArea"
      "TextField"
      "Toolbar"
      "iOS::Toolbar"
      "WebView"
    ]

      assert.throws (-> $("<#{viewName}>").append $("<View>")), "Should not be able to append to a #{viewName}"

      assert.throws (-> $("<#{viewName}>").remove $("<View>")), "Should not be able to remove from a #{viewName}"

  describe 'special containers', ->

    describe 'TableView', ->

      it 'should handle append and remove of rows', ->

        $table = $('<TableView>')

        assert.equal $table[0].rows.length, 0

        $row = $('<TableViewRow>')
          .appendTo $table

        assert.equal $table[0].rows.length, 1

        $row.remove()

        assert.equal $table[0].rows.length, 0

      it 'should handle append and remove of sections', ->

        $table = $('<TableView>')

        assert.equal $table[0].sections.length, 0

        $row = $('<TableViewSection>')
          .appendTo $table

        assert.equal $table[0].sections.length, 1

        $row.remove()

        assert.equal $table[0].sections.length, 0

    describe 'TableViewSection', ->

      it 'should only handle append and remove of rows', ->

        $table = $('<TableView>')
        $section = $('<TableViewSection>').appendTo $table

        assert.equal $section[0].children.length, 0

        $row = $('<TableViewRow>')
          .appendTo $section

        assert.equal $table[0].rows.length, 1
        assert.equal $section[0].rows.length, 1

        assert.throws ->
          $section.append $('<View>')

        $row.remove()

        assert.equal $table[0].rows.length, 0
        assert.equal $section[0].rows.length, 0

    describe 'Picker', ->

      it 'should handle append and remove of rows', ->

        $picker = $('<Picker>')

        assert.equal $picker[0].columns.length, 0

        $row = $('<PickerRow>')
          .appendTo $picker

        assert.equal $picker[0].columns.length, 1
        assert.equal $picker[0].columns[0].rows.length, 1

        assert.throws ->
          $picker.append $('<View>')

        $row.remove()

        assert.equal $picker[0].columns[0].rows.length, 0

      it 'should handle append and remove of columns', ->

        $picker = $('<Picker>')

        assert.equal $picker[0].columns.length, 0

        $column = $('<PickerColumn>')
          .appendTo $picker

        assert.equal $picker[0].columns.length, 1

        $column.remove()

        assert.equal $picker[0].columns.length, 0

    describe 'PickerColumn', ->

      it 'should only handle append and remove of rows', ->

        $column = $('<PickerColumn>')

        assert.equal $column[0].rows.length, 0

        $row = $('<PickerRow>')
          .appendTo $column

        assert.equal $column[0].rows.length, 1

        assert.throws ->
          $column.append $('<View>')

        $row.remove()

        assert.equal $column[0].rows.length, 0

    describe 'TabGroup', ->

      it 'should only handle append and remove of tabs', ->

        $tabGroup = $('<TabGroup>')

        assert.equal $tabGroup[0].tabs.length, 0

        $tab = $('<Tab>')
          .appendTo $tabGroup

        assert.equal $tabGroup[0].tabs.length, 1

        assert.throws ->
          $tabGroup.append $('<View>')

        $tab.remove()

        assert.equal $tabGroup[0].tabs.length, 0

    describe 'top-level containers', ->

      it 'should not allow top-level containers to be added to other views', ->

        for viewName in [
          "Tab"
          "TabGroup"
          "iPhone::NavigationGroup"
          "iPad::SplitWindow"
        ]

          assert.throws ->
            $('<View>').append $("<#{viewName}>")
