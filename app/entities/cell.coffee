define ["cs!application", "cs!environment", "cs!entities/plot", "cs!entities/unit", "backbone", "backbone.relational"], (Hexa, Environment, Plot, Unit, Backbone) ->
  # BASE

  class BaseModel extends Backbone.RelationalModel
    x: -> @get "x"
    y: -> @get "y"

  class BaseCollection extends Backbone.Collection
    # ...

  # PLOT

  class PlotModel extends BaseModel
    relations: [
      {
        type           : Backbone.HasOne
        key            : "object"
        relatedModel   : Plot.Model
        collectionType : Plot.Collection
      }
    ]

  class PlotCollection extends BaseCollection
    model: PlotModel

  # UNIT

  class UnitModel extends BaseModel
    relations: [
      {
        type           : Backbone.HasOne
        key            : "object"
        relatedModel   : Unit.Model
        collectionType : Unit.Collection
      }
    ]

  class UnitCollection extends BaseCollection
    model: UnitModel

  # EXPORTS

  PlotModel      : PlotModel
  PlotCollection : PlotCollection
  UnitModel      : UnitModel
  UnitCollection : UnitCollection