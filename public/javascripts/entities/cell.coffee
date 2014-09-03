define ["cs!app", "cs!entities/plot", "cs!entities/unit", "backbone", "backbone.relational"], (Hexa, Plot, Unit, Backbone) ->
  class BaseModel extends Backbone.RelationalModel
    x: -> @get "x"
    y: -> @get "y"

    animationTag: ->
      @get "animationTag"

  class PlotModel extends BaseModel
    relations: [
      {
        type           : Backbone.HasOne
        key            : "object"
        keySource      : "object_id"
        relatedModel   : Plot.Model
        collectionType : Plot.Collection
      }
    ]

    defaults:
      state: ""

    state: (value) ->
      # if value isnt undefined then @set("state", value) else @get("state")
      @set "state", value

    getState: ->
      @get "state"

  class PlotCollection extends Backbone.Collection
    model: PlotModel

    unoccupied: (units, coords) ->
      new @constructor coords.map (coords) =>
        @find (plot) -> plot.x() is coords.x and plot.y() is coords.y and not units.exists(coords)

    state: (value) ->
      @each (plot) -> plot.state(value) if plot.getState() isnt value

  # UNIT

  class UnitModel extends BaseModel
    relations: [
      {
        type           : Backbone.HasOne
        key            : "object"
        keySource      : "object_id"
        relatedModel   : Unit.Model
        collectionType : Unit.Collection
      }
    ]

    isColor: (color) ->
      @get("metadata").owner is color

    move: (x, y) ->
      @set(x: x, y: y)
      @trigger("move")

    destroy: (options) ->
      @trigger "destroy", @, @collection, options

  class UnitCollection extends Backbone.Collection
    model: UnitModel

    withOwner: (color) ->
      new @constructor @filter (unit) -> unit.get("metadata").owner is color

    exists: (coords) ->
      !!@findWhere coords

    enemyFor: (baseUnit, coords) ->
      new @constructor coords.map (coords) =>
        @find (unit) ->
          unit.x() is coords.x and unit.y() is coords.y and unit.get("metadata").owner isnt baseUnit.get("metadata").owner

  # EXPORTS

  PlotModel      : PlotModel
  PlotCollection : PlotCollection
  UnitModel      : UnitModel
  UnitCollection : UnitCollection
