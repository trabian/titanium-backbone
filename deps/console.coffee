# Internal: Create a space-delimited representation of the provided
# 'statements' array by converting any non-string elements to strings
# using JSON.stringify and joining the array with a space.
stringify = (statements) ->

  strings = for statement in statements
    if _.isString statement
      statement
    else
      JSON.stringify statement

  strings.join ' '

# Internal: Log stringified version of statements at the specified log
# level.
#
# level - String representing severity level
# statements - Array of statements to be logged, including strings,
#   objects, and arrays
#
# Examples
#
#   log 'info', [ 'Print', 'is', { object: { with: ['a', 'child array'] } } ]
#   # Equivalent to Ti.API.debug 'Print this {"object":{"with":["a","child array"]}}'
#
# Returns nothing
log = (level, statements) ->
  Ti.API.log level, stringify statements
  return

@console =

  # Public: Alias to console.log
  debug: (statements...) ->
    @log statements

  # Public: Ti.API.debug stringified statements
  log: (statements...) ->
    log 'debug', statements

  # Public: Ti.API.info stringified statements
  info: (statements...) ->
    log 'info', statements

  # Public: Ti.API.warn stringified statements
  warn: (statements...) ->
    log 'warn', statements

  # Public: Ti.API.error stringified statements
  error: (statements...) ->
    log 'error', statements

_oldAlert = @alert

# Public: Override existing global alert method to handle
# stringification of statements
#
# statements - Array of statements to be included in alert,
#   including strings, objects, and arrays
#
# Returns nothing
@alert = (statements...) ->
  _oldAlert stringify statements
  return
