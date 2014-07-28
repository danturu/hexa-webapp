define ["cs!application", "cs!environment", "backbone", "backbone.relational"], (Hexa, Environment, Backbone) ->
  class Model extends Backbone.RelationalModel
    name: ->
      @get "name"

    description: ->
      @get "description"

  class Collection extends Backbone.Collection
    model: Model

    comparator: (planet) ->
      planet.get "position"

  Hexa.addInitializer ->
    Hexa.entitiesCache.planets = new Collection Hexa.bootstrapData.objects.planets

  Hexa.reqres.setHandler "entities:planets", ->
    Hexa.entitiesCache.planets

  # EXPORTS

  Model      : Model
  Collection : Collection