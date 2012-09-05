styles = require('styles').ui.form.table

Table = require 'core/views/ui/table'

module.exports = class FormTable extends Table

  attributes: styles.view

  itemView: require './row'
