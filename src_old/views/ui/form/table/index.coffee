styles = require('styles').ui.form.table

Table = require 'views/ui/table'

module.exports = class FormTable extends Table

  attributes: styles.view

  initialize: ->

    @options = _.defaults {}, @options,
      rowClass: require './row'
      autoHeight: true

    super
