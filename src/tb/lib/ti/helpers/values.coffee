TITANIUM_VALUE = /Ti\.(.*)/

convertIfNeeded = (value) ->

  if _.isString(value) and match = value.match TITANIUM_VALUE

    _.reduce match[1]?.split('.'), (hashPart, subKey) ->
      hashPart[subKey]
    , Ti

  else
    value

module.exports =

  convertTi: (valueOrHash) ->

    if _.isObject valueOrHash

      for key, value of valueOrHash
        valueOrHash[key] = convertIfNeeded value

      valueOrHash

    else
      convertIfNeeded valueOrHash


