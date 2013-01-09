network = require './network'

module.exports =

  forwardGeocoder: (query, callback) ->

    url = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=true&'

    url += "address=#{encodeURIComponent query}"

    network.request url,
      type: 'GET'
      success: (data) ->

        if geometry = data.results?[0].geometry

          callback
            success: true
            latitude: geometry.location?.lat
            longitude: geometry.location?.lng

        else
          callback
            success: false

