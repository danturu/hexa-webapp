define ["cs!app", "cs!entities/game", "backbone", "backbone.relational"], (Hexa, Game, Backbone) ->
  GameModel      = -> require("cs!entities/game").Model
  GameCollection = -> require("cs!entities/game").Collection

  class Model extends Backbone.RelationalModel
    urlRoot: "#{Hexa.ENDPOINT_URL}/api/v1/users"

    relations: [
      {
        type           : Backbone.HasMany
        key            : "games"
        relatedModel   : GameModel
        collectionType : GameCollection
        includeInJSON  : false
      }
    ]

    name: ->
      @get("name")

    avatarUrl: ->
      @get("avatar_url")

    hasAvatar: ->
      true # since Hexa server provide fallback

  # HANDLERS

  Hexa.addInitializer ->
    Hexa.entitiesCache.currentUser = new Model Hexa.bootstrapData.currentUser

  Hexa.reqres.setHandler "app:currentUser", ->
    Hexa.entitiesCache.currentUser

  # EXPORTS

  Model : Model
