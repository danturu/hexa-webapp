define ["cs!application", "cs!environment", "backbone", "backbone.relational"], (Hexa, Environment, Backbone) ->
  class Model extends Backbone.RelationalModel
    @tag: "unit"

  class Collection extends Backbone.Collection
    model: Model

  Hexa.addInitializer ->
    new Collection Hexa.bootstrapData.objects.units

  # EXPORTS

  Model      : Model
  Collection : Collection