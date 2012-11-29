class TitaniumMapView extends TitaniumView

  constructor: (attributes) ->
    for name, value of attributes
      @[name] = value
    @children = []
    @annotations = []

  addAnnotation: (annotation) ->
    @annotations.push annotation

  removeAnnotation: (annotation) ->
    @annotations = _.without @annotations, annotation

class TitaniumMapAnnotationView extends TitaniumView

Ti.Map.createAnnotation = (attributes) ->

  new TitaniumMapAnnotationView attributes

Ti.Map.createView = (attributes) ->

  new TitaniumMapView attributes
