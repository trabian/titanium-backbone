helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$.append and $.remove methods on special containers', ->

  it 'should throw an error on non-containers', ->

    for viewName in [
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
