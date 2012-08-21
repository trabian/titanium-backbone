styles = require('styles').ui

Table = require '../index'

ViewList = require 'presenters/view_list'

module.exports = class DetailsTable extends Table

  attributes: =>

    if @options.plain
      styles.table.details.plain
    else
      styles.table.details.styled

  initialize: ->

    @options = _.defaults {}, @options,
      rowClass: require './row'

    super
