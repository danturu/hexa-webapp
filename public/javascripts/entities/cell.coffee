define ["cs!app", "cs!entities/plot", "cs!entities/unit", "backbone", "backbone.relational"], (Hexa, Plot, Unit, Backbone) ->

  # BASE

  class BaseModel extends Backbone.RelationalModel
    x: -> @get "x"
    y: -> @get "y"

    animationTag: ->
      @get "animationTag"

  # PLOT

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

    state: (value) ->
      if value isnt undefined then @set("state", value) else @get("state")

  class PlotCollection extends Backbone.Collection
    model: PlotModel

    unoccupied: (units, coords) ->
      new @constructor coords.map (coords) =>
        @find (plot) -> plot.x() is coords.x and plot.y() is coords.y and not units.exists(coords)

    state: (value) ->
      @each (plot) -> plot.state(value) if plot.state() isnt value

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

  class UnitCollection extends Backbone.Collection
    model: UnitModel

    exists: (coords) ->
      !!@findWhere coords

  # EXPORTS

  PlotModel      : PlotModel
  PlotCollection : PlotCollection
  UnitModel      : UnitModel
  UnitCollection : UnitCollection
