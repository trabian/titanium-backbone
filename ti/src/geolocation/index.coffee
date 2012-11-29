locationServicesEnabled = true

Ti.Geolocation = { "PROVIDER_GPS", locationServicesEnabled }

Ti.Geolocation.getCurrentPosition = (callback) =>

  callback
    coords:
      latitude: 20
      longitude: 30
