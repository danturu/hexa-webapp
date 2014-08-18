define ["fabric", "backbone", "underscore"], (Fabric, Backbone, _) ->
  class Fabric.ItemView
    # Event emitter DSL same as in Marrionete.View:

    events      : {}
    triggers    : {}
    modelEvents : {}

    constructor: (options) ->
      _.extend @, Backbone.Events
      _.extend @, options

      @initialize options

    render: (callback) -> @onRender (object) =>
      @object = object

      # setup eventing system...

      @_delegateEvents()
      @_configureTriggers()
      @_delegateEntityEvents()

      # object now can be added to canvas...

      callback @

    initialize: (options) ->
      # Override it with your own initialization logic.

    onRender: (callback) ->
      # Should callback with valid Fabric object.

    onShow: ->
      # Triggered right after Fabric object was added to canvas.

    onDestroy: ->
      # Triggered right after Fabric object was removed from canvas.

    _destroy: ->
      @object.remove()
      @stopListening()

      # The onDestroy method will be passed any arguments that destroy was invoked with
      # to let you handle any additional clean up without having to override the destroy method.

      @onDestroy arguments

    _delegateEvents: ->
      _.each @events, (methodName, event) =>
        @listenTo @object, event, => @[methodName]()

    _configureTriggers: ->
      # Handler will receive a single argument that includes view, model and object.

      _.each @triggers, (triggerName, event) =>
        @listenTo @object, event, => @trigger triggerName, view: @, model: @model, object: @object

    _delegateEntityEvents: ->
      _.each @modelEvents, (methodName, event) =>
        @listenTo @model, event, (options) => @[methodName](options)
