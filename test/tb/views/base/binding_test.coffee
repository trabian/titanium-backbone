helpers = require '../../../helpers'

{ assert } = helpers.chai

describe 'Backbone.View binding', ->

  beforeEach ->

    class SampleView extends Backbone.View

      events: ->
        'change TextField': (e) => @someValue = e.value

      bindings:
        'Label': 'name'
        'TextField': 'name'
        'TextArea': 'name'
        'SearchBar': 'name'
        'Switch': 'acceptance'
        'Slider': 'age'

      render: ->

        @$el.html '<Label /><TextField /><TextArea /><Switch /><SearchBar /><Slider />'

        @stickit()

        @

    @model = new Backbone.Model
      name: 'Some Name'
      acceptance: false
      age: 33

    @sampleView = new SampleView
      model: @model

    @$el = @sampleView.render().$el

  it 'should initialize the text of the element based on the passed value', ->

    assert.equal @$el.find('Label').text(), 'Some Name'

  it 'should update the text of the element when the model changes', ->

    @model.set
      name: 'Some New Name'

    assert.equal @$el.find('Label').text(), 'Some New Name'

  describe 'TextFields, TextAreas, and SearchBars', ->

    beforeEach ->
      @$fields = for sel in ['TextField', 'TextArea', 'SearchBar']
        @$el.find sel

    it 'should initialize the value of the element based on the passed value', ->

      for $field in @$fields
        assert.equal $field.val(), @model.get 'name'

      @model.set
        name: 'Some New Name'

      for $field in @$fields
        assert.equal $field.val(), @model.get 'name'

    it 'should update the model value when the text field is changed', ->

      for $field, index in @$fields

        name = "Updated Name #{index}"

        $field[0].setValue name

        assert.equal @model.get('name'), name

    it 'should not prevent existing event listeners from working', ->

      @$el.find('TextField').val 'Some New Value'

      assert.equal @sampleView.someValue, 'Some New Value'

  describe 'Switches', ->

    beforeEach ->
      @$field = @$el.find 'Switch'

    it 'should initialize the value of the switch based on the passed value', ->

      assert.isFalse @$field.val()

      @model.set
        acceptance: true

      assert.isTrue @$field.val()

    it 'should update the model value when the switch is changed', ->

      @$field[0].setValue true

      assert.isTrue @model.get 'acceptance'

  describe 'Sliders', ->

    beforeEach ->
      @$field = @$el.find 'Slider'

    it 'should initialize the value of the switch based on the passed value', ->

      assert.equal @$field.val(), 33

      @model.set
        age: 40

      assert.equal @$field.val(), 40

    it 'should update the model value when the slider is changed', ->

      @$field[0].setValue 50

      assert.equal @model.get('age'), 50

