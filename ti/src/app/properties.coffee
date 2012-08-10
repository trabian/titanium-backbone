Ti.App.Properties =

  store: {}

  getString: (key) ->
    Ti.App.Properties.store[key]

  setString: (key, value) ->
    Ti.App.Properties.store[key] = value