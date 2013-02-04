viewStyles = require('styles/ui/android').actionBar.actions

CollectionView = require 'core/views/collection'

ActionView = require './action'

module.exports = class ActionsView extends CollectionView

  attributes: viewStyles.view

  itemView: ActionView
