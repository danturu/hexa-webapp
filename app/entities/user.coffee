define ["cs!application", "cs!environment", "cs!entities/game", "backbone", "backbone.relational"], (Hexa, Environment, Game, Backbone) ->
  class Model extends Backbone.RelationalModel
    urlRoot: "#{Environment.ENDPOINT}/api/v1/audio"

    relations: [
      {
        type           : Backbone.HasMany
        key            : "games"
        relatedModel   : Game.Model
        collectionType : Game.Collection
      }
    ]

    name: ->
      @get "name"

  Hexa.addInitializer ->
    Hexa.entitiesCache.currentUser = new Model Hexa.bootstrapData.currentUser

  Hexa.reqres.setHandler "entities:currentUser", ->
    Hexa.entitiesCache.currentUser

  # EXPORTS

  Model : Model