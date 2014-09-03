# DIRTY CLASS!

define ["fabric", "backbone", "async", "underscore"], (Fabric, Backbone, Sync, _) ->
  class Fabric.CollectionView
    @viewOptions : ["collection"]

    childViewEventPrefix : "childview"

    constructor: (options) ->
      (_ @).extend (_ options).pick @constructor.viewOptions
      (_ @).extend Backbone.Events

      @children = []
      @initialize(options)

      @listenTo @collection, "add", (model) =>
        @renderChild model, (error, view) =>
          @canvasView.canvas.add view.object
          view.onAdd()

      @listenTo @collection, "remove", (model, collection) =>
        view = _.find @children, (child) -> child.model == model
        view.destroy()

    initialize: (options) ->

    render: (canvasView, callback=->) ->
      @canvasView = canvasView
      Sync.eachSeries @collection.toArray(), @renderChild.bind(@), (error) =>
        _.each @children, (childView) ->
          canvasView.canvas.add childView.object
          childView.onShow()

        Fabric.redraw()

        callback @

    renderChild: (child, callback) ->
      childViewOptions = @childViewOptions
      childViewOptions = childViewOptions.call(this, child) if _.isFunction(@childViewOptions)

      new @childView(_.extend model: child, childViewOptions).render (childView) =>
        @proxyChildEvents childView;
        @children.push childView;
        callback null, childView;

    getObjects: ->
      (_ @children).map (child) -> child.object

    getChildren: ->
      @children

    proxyChildEvents: (view) ->
      @listenTo view, "all", (name, event) =>
        @trigger "#{@childViewEventPrefix}:#{name}", event
