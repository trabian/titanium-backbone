module.exports =

  build: (options) =>

    field = options.field

    fieldClass = require "./#{field.get 'as'}"

    new fieldClass
      controller: options.controller
      presenter: field
