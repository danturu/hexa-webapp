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
      @object.setTag @model.state()

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

    onShow: ->
      @object.play tag: "live", duration: 300, repeat: 1

    onDestroy: ->
      cleatTimeout @clownAnimation

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
    ###

      clown = =>
        @object.play(tag: "clown", duration: 300, repeat: 1) unless @object.isAnimating()

      # @clownAnimation = setInterval clown, _.random(3, 7) * 1000

    jump: ->
      @object.setTag("jump").play(duration: 500, repeat: 1, => @object.setTag(null)) #, (-> ),  # , => 2@showObject())

      @object.animate { left: @grid.getX(@model.x()), top: @grid.getY(@model.y()) }, duration: 550, easing: fabric.util.ease["easeInOutQuad"], onChange: -> Backbone.trigger "canvas:render"

      #@currentObject.animate "top",  @grid.getY(@model.y()), duration: 1000,  easing: fabric.util.ease["easeInOutQuad"]

      #  var animateBtn = document.getElementById('animate');
      #  animateBtn.onclick = function() {
      #    animateBtn.disabled = true;
      #    rect.animate('left', rect.getLeft() === 100 ? 400 : 100, {
      #      duration: 1000,
      #      onChange: canvas.renderAll.bind(canvas),
      #      onComplete: function() {
      #        animateBtn.disabled = false;
      #      },
      #      easing: fabric.util.ease[document.getElementById('easing').value]
      #    });
      #  };
      #})();
    ###

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

  class GameView extends Marionette.LayoutView
    @VIEW_S : 640 * if window.devicePixelRatio > 1 then 2 else 1
    @BASE_W : 210
    @BASE_H : 182

    template  : [TEMPLATES, "game"]
    tagName   : "article"
    className : "game"

    onRender: ->
      @.$("section.planet img").attr src: @model.imageUrl()

    onShow:->
      @canvas = new Fabric.Canvas @.$("section.planet canvas").get(0), width: @constructor.VIEW_S, height: @constructor.VIEW_S

    show: (fabricView) ->
      fabricView.render @

  # EXPORTS

  PlotView  : PlotView
  UnitView  : UnitView
  PlotsView : PlotsView
  UnitsView : UnitsView
  GameView  : GameView
