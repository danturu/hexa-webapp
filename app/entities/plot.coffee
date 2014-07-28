define ["cs!application", "cs!environment", "backbone", "backbone.relational"], (Hexa, Environment, Backbone) ->
  class Model extends Backbone.RelationalModel
    @tag: "plot"

  class Collection extends Backbone.Collection
    model: Model

  Hexa.addInitializer ->
    new Collection Hexa.bootstrapData.objects.plots

  # EXPORTS

  Model      : Model
  Collection : Collection