define ["text!modules/games/show/templates.html", "cs!lib/fabric/cache", "fabric", "marionette", "async", "jquery", "underscore", "cs!lib/fabric/views/collection", "cs!lib/fabric/views/item", "cs!lib/fabric/objects/sprite"], (TEMPLATES, Cache, Fabric, Marionette, ASync, $, _) ->
  class PlotView extends Fabric.ItemView
    triggers:
      "mouseup" : "click"

    modelEvents:
      "change:state" : "onChange"

    initialize: (options) ->
      @grid = options.grid

    onRender: (callback) ->
      object = new Fabric.Sprite
        tag    : null
        left   : @grid.getX @model.x()
        top    : @grid.getY @model.y()
        scaleX : @grid.scaleIn()
        scaleY : @grid.scaleIn()

      ASync.each @collection.toArray(), retrieveImage.bind(@, object), callback.bind(@, object)

    onChange: ->
      @object.setTag @model.getState()

    retrieveImage = (object, model, callback) =>
      Cache.get model.id, loadImage.bind(@, model.url()), (data) ->
        # TODO: no exception catching...

        object.putImage model.tag(), data, model.spriteW(), model.spriteH()

        # NOTE: no guarantee that view rendered properly...

        callback()

    loadImage = (url, callback) =>
      Fabric.util.loadImage url, callback, @, "anonymous"

  class UnitView extends Fabric.ItemView
    triggers:
      "mouseup" : "click"

    modelEvents:
      "animate" : "onAnimate"
      "move"    : "onMove"

    initialize: (options) ->
      @grid = options.grid

    destroy: ->
      @object.play tag: "die", duration: 300, repeat: 1, =>
        @_destroy()
        @model.trigger("fabric:ddestroy")
        Fabric.redraw()

    onRender: (callback) ->
      object = new Fabric.Sprite
        tag    : null
        left   : @grid.getX @model.x()
        top    : @grid.getY @model.y()
        scaleX : @grid.scaleIn()
        scaleY : @grid.scaleIn()

      ASync.each @collection.toArray(), retrieveImage.bind(@, object), callback.bind(@, object)

    onAdd: ->
      # alert JSON.stringify @model.attributes
      @object.play tag: "live", duration: 300, repeat: 1

    onShow: ->
      @object.play tag: "live", duration: 300, repeat: 1

    onDestroy: ->
      clearTimeout @clownAnimation

    onAnimate: (options, force) ->
      @object.play options if force or not @object.isAnimating()

    retrieveImage = (object, model, callback) =>
      Cache.get model.id, loadImage.bind(@, model.url()), (data) ->
        # TODO: no exception catching...

        object.putImage model.tag(), data, model.spriteW(), model.spriteH()

        # NOTE: no guarantee that view rendered properly...

        callback()

    loadImage = (url, callback) =>
      Fabric.util.loadImage url, callback, @, "anonymous"

      clown = =>
        @object.play(tag: "clown", duration: 300, repeat: 1) unless @object.isAnimating()

      # @clownAnimation = setInterval clown, _.random(3, 7) * 1000

    onMove: ->
      @object.bringToFront()
      @object.play tag: "move", duration: 500, repeat: 1, =>
        @object.setTag(""); Fabric.redraw();

      @object.animate { left: @grid.getX(@model.x()), top: @grid.getY(@model.y()) }, duration: 550, easing: fabric.util.ease["easeInOutQuad"], onChange: Fabric.redraw

  class PlotsView extends Fabric.CollectionView
    childView            : PlotView
    childViewEventPrefix : "plot"

    initialize: (options) ->
      @grid = options.grid

    childViewOptions: (plot) ->
      grid: @grid, collection: plot.get("object").get("images")

  class UnitsView extends Fabric.CollectionView
    childView            : UnitView
    childViewEventPrefix : "unit"

    initialize: (options) ->
      @grid = options.grid

    childViewOptions: (unit) ->
      grid: @grid, collection: unit.get("object").get("images")

  class PlayerView extends Marionette.ItemView
    template  : [TEMPLATES, "player"]
    className : "player"

    serializeData: ->
      name : @model.name()

    onRender: ->
      @.$("div.avatar").css "background-image" : "url(#{@model.avatarUrl()})" if @model.hasAvatar()

    renderScore: (value) ->
      @.$("div.score").html value

  class GameView extends Marionette.CompositeView
    @VIEW_S : 640 * if window.devicePixelRatio > 1 then 2 else 1
    @BASE_W : 210
    @BASE_H : 182

    template  : [TEMPLATES, "game"]
    tagName   : "article"
    className : "game"
    childView            : PlayerView
    childViewContainer   : "section.players"
    childViewEventPrefix : "player"

    triggers:
      "click a.exit" : "exit"

    initialize: ->
      @listenTo @model.units(), "add remove", @renderScore

    onRender: ->
      @.$("section.planet img").attr src: @model.planet().imageUrl()

    onShow:->
      @canvas = new Fabric.Canvas @.$("canvas").get(0), width: @constructor.VIEW_S, height: @constructor.VIEW_S

    onRenderCollection: ->
      @renderScore()

    show: (fabricView) ->
      fabricView.render @

    renderScore: ->
      score = @model.scoreFor @collection.first()

      @children.findByIndex(0).renderScore(score[0]);
      @children.findByIndex(1).renderScore(score[1]);

  # EXPORTS

  PlotView  : PlotView
  UnitView  : UnitView
  PlotsView : PlotsView
  UnitsView : UnitsView
  GameView  : GameView
