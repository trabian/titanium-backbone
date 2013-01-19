module.exports =

  isObservable: ($el) ->
    $el[0]._viewName in [
      'TextField'
      'TextArea'
      'Switch'
      'SearchBar'
      'Slider'
    ]

  updateEl: ($el, val, config) ->

    updateMethod = config.updateMethod || 'text';

    if @isObservable $el
      $el.val val
    else
      $el[updateMethod] val

  getElVal: ($el) ->

    $el.val() if @isObservable $el
