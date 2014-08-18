define ["cs!app", "backbone", "backbone.relational"], (Hexa, Backbone) ->
  class Model extends Backbone.RelationalModel
    name: ->
      @get "name"

    description: ->
      @get "description"

    imageUrl: ->
      @get "image_url"

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
