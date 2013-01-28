module.exports =

  handleResponses: (s, xhr, responses) ->

    ct = undefined
    firstDataType = undefined
    finalDataType = undefined

    { contents, dataTypes, responseFields } = s

    for type, value of responseFields
      if type of responses
        xhr[responseFields[type]] = responses[type]

    while dataTypes[0] is '*'

      dataTypes.shift()

      unless ct?
        ct = s.mimeType or xhr.getResponseHeader 'Content-Type'

    if ct

      for type, matcher of contents

        if matcher?.test ct
          dataTypes.unshift type
          break

    if responses[dataTypes[0]]
      finalDataType = dataTypes[0]

    else

      for type, value of responses

        if (! dataTypes[0]) or s.converters["#{type} #{dataTypes[0]}"]
          finalDataType = type
          break

        unless firstDataType
          firstDataType = type

      finalDataType ?= firstDataType

    if finalDataType

      unless finalDataType is dataTypes[0]
        dataTypes.unshift finalDataType

      return responses[finalDataType]

  # Chain conversions given the request and the original response
  convert: (s, response) ->

    dataTypes = s.dataTypes.slice()
    prev = dataTypes[0]
    converters = {}

    conv = undefined
    conv2 = undefined

    i = 0

    if s.dataFilter
      response = s.dataFilter response, s.dataType

    if dataTypes[1]

      for name, converter of s.converters
        converters[name.toLowerCase()] = converter

    while current = dataTypes[++i]

      unless current is '*'

        unless prev is '*' or prev is current

          conv = converters["#{prev} #{current}"] or converters["* #{current}"]

          unless conv

            for conv2 in converters
              tmp = conv2.split " "

              if tmp[1] is current

                conv = converters["#{prev} #{tmp[0]}"] or converters["* #{tmp[0]}"]

                if conv

                  if conv is true
                    conv = converters[conv2]

                  else if converters[conv2] != true
                    current = tmp[0]
                    dataTypes.splice i--, 0, current

                  break

          unless conv is true

            if conv and s["throws"]
              response = conv response
            else
              try
                response = conv response
              catch error

                response =
                  state: "parsererror"
                  error: if conv then error else "No conversion from #{prev} to #{current}"

                return response

      prev = current

    state: 'success'
    data: response

  #   var conv, conv2, current, tmp,
  #     converters = {},
  #     i = 0,
  #     // Work with a copy of dataTypes in case we need to modify it for conversion
  #     dataTypes = s.dataTypes.slice(),
  #     prev = dataTypes[ 0 ];

  #   // Apply the dataFilter if provided
  #   if ( s.dataFilter ) {
  #     response = s.dataFilter( response, s.dataType );
  #   }

  #   // Create converters map with lowercased keys
  #   if ( dataTypes[ 1 ] ) {
  #     for ( conv in s.converters ) {
  #       converters[ conv.toLowerCase() ] = s.converters[ conv ];
  #     }
  #   }

  #   // Convert to each sequential dataType, tolerating list modification
  #   for ( ; (current = dataTypes[++i]); ) {

  #     // There's only work to do if current dataType is non-auto
  #     if ( current !== "*" ) {

  #       // Convert response if prev dataType is non-auto and differs from current
  #       if ( prev !== "*" && prev !== current ) {

  #         // Seek a direct converter
  #         conv = converters[ prev + " " + current ] || converters[ "* " + current ];

  #         // If none found, seek a pair
  #         if ( !conv ) {
  #           for ( conv2 in converters ) {

  #             // If conv2 outputs current
  #             tmp = conv2.split(" ");
  #             if ( tmp[ 1 ] === current ) {

  #               // If prev can be converted to accepted input
  #               conv = converters[ prev + " " + tmp[ 0 ] ] ||
  #                 converters[ "* " + tmp[ 0 ] ];
  #               if ( conv ) {
  #                 // Condense equivalence converters
  #                 if ( conv === true ) {
  #                   conv = converters[ conv2 ];

  #                 // Otherwise, insert the intermediate dataType
  #                 } else if ( converters[ conv2 ] !== true ) {
  #                   current = tmp[ 0 ];
  #                   dataTypes.splice( i--, 0, current );
  #                 }

  #                 break;
  #               }
  #             }
  #           }
  #         }

  #         // Apply converter (if not an equivalence)
  #         if ( conv !== true ) {

  #           // Unless errors are allowed to bubble, catch and return them
  #           if ( conv && s["throws"] ) {
  #             response = conv( response );
  #           } else {
  #             try {
  #               response = conv( response );
  #             } catch ( e ) {
  #               return { state: "parsererror", error: conv ? e : "No conversion from " + prev + " to " + current };
  #             }
  #           }
  #         }
  #       }

  #       // Update prev for next iteration
  #       prev = current;
  #     }
  #   }

  #   return { state: "success", data: response };
  # }

