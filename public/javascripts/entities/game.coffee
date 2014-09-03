define ["cs!app", "cs!entities/planet", "cs!entities/user", "cs!entities/friend", "cs!entities/cell", "backbone", "backbone.relational"], (Hexa, Planet, User, Friend, Cell, Backbone) ->
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
      @get("state")

    eventName: ->
      @get("event_name")

    eventTime: ->
      @get("event_time")

    planet: ->
      @get("planet")

    w: ->
      @get("w")

    h: ->
      @get("h")

    turnOf: ->
      @get("turn_of")

    whitePlayer: ->
      @get("white_player")

    blackPlayer: ->
      @get("black_player")

    plots: ->
      @get("plots")

    units: ->
      @get("units")

    channel: ->
      ["game", @id].join(":")

    turn: (params) ->
      Backbone.customRequest @, { url: "#{@url()}/turn", method: "put" }, params

    canTurn: (player) ->
      player is @turnOf()

    opponentFor: (player) ->
      if @state() is "waiting"
        new Friend.Model @get("metadata").opponent
      else
        if player is @whitePlayer()
          @blackPlayer()
        else
          @whitePlayer()

    scoreFor: (player) ->
      whiteScore = @units().withOwner("white").size()
      blackScore = @units().withOwner("black").size()

      if player is @whitePlayer()
        [whiteScore, blackScore]
      else
        [blackScore, whiteScore]

  class Collection extends Backbone.Collection
    model: Model

    comparator: (game) ->
      -new Date(game.eventTime()).getTime()

    active: ->
      new @constructor @filter (game) -> game.state() isnt "finished"

  # HANDLERS

  Hexa.reqres.setHandler "entities:games", ->
    Hexa.request("app:currentUser").get("games")

  Hexa.reqres.setHandler "entities:game", (id) ->
    Model.findOrCreate { id: id }, { merge: false }

  # EXPORTS

  Model      : Model
  Collection : Collection



#    channels = Hexa.request("entities:games").map (game) -> game.channel()
#
#    ws = new WebSocket("wss://server.hexa.dev/")
#    ws.onmessage = (message) ->
#      console.log "message"
#      console.log message
#
#    ws.onopen = (data) ->
#      socketId = Math.random()
#      console.log "opened"
#
#      srl = "#{Hexa.ENDPOINT_URL}/api/v1/messages/subscribe"
#
#      $.post srl,{ channels: channels, socket_id: socketId },  (r) ->
#        _.each r, (token, channel) ->
#          ws.send JSON.stringify(event: "ws:subscribe", channel: channel, token: token)
#
#        console.log "res"


