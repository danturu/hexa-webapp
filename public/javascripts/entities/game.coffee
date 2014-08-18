define ["cs!app", "cs!entities/planet", "cs!entities/user", "cs!entities/cell", "backbone", "backbone.relational"], (Hexa, Planet, User, Cell, Backbone) ->
  UserModel = -> require("cs!entities/user").Model

  class Model extends Backbone.RelationalModel
    urlRoot: "#{Hexa.ENDPOINT_URL}/api/v1/games"

    relations: [
      {
        type          : Backbone.HasOne
        key           : "planet"
        keySource     : "planet_id"
        relatedModel  : Planet.Model
        includeInJSON : "id"
      }

      {
        type          : Backbone.HasOne
        key           : "white_player"
        relatedModel  : UserModel
        includeInJSON : false
      }

      {
        type          : Backbone.HasOne
        key           : "black_player"
        relatedModel  : UserModel
        includeInJSON : false
      }

      {
        type          : Backbone.HasOne
        key           : "turn_of"
        keySource     : "turn_of_id"
        relatedModel  : UserModel
        includeInJSON : false
      }

      {
        type           : Backbone.HasMany
        key            : "plots"
        relatedModel   : Cell.PlotModel
        collectionType : Cell.PlotCollection
        includeInJSON  : false
      }

      {
        type           : Backbone.HasMany
        key            : "units"
        relatedModel   : Cell.UnitModel
        collectionType : Cell.UnitCollection
        includeInJSON  : false
      }
    ]

    state: ->
      @get "state"

    planet: ->
      @get "planet"

    w: ->
      @get "w"

    h: ->
      @get "h"

    plots: ->
      @get "plots"

    units: ->
      @get "units"

    join: ->
      Backbone.customRequest @, { url: @url() + "/join", method: "put" }

    turn: (params) ->
      Backbone.customRequest @, { url: @url() + "/turn", method: "put" }, params

    turnOf: (player) ->
      player.id is @get("turn_of").id

    colorOf: (player) ->
      if player.id is @get("black_player").id then "black" else "white"

    opponentFor: (player) ->
      @get if player.id is @get("black_player").id then "white_player" else "black_player"

    noOpponent: ->
      @get("state") is "waiting"

  class Collection extends Backbone.Collection
    model: Model

    started: ->
      new @constructor @filter (game) -> game.state() isnt "waiting"

  Hexa.reqres.setHandler "entities:games", ->
    Hexa.request("app:currentUser").get("games")

  Hexa.reqres.setHandler "entities:game", (id) ->
    Model.findOrCreate { id: id }, { merge: false }

  # EXPORTS

  Model      : Model
  Collection : Collection
