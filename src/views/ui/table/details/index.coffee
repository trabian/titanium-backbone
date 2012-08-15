styles = require('styles').ui

Table = require '../index'

ViewList = require 'presenters/view_list'

module.exports = class DetailsTable extends Table

  attributes: styles.table.details.view

  initialize: ->

    @options = _.defaults {}, @options,
      rowClass: require './row'

    super
