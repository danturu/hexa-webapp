define ["cs!app", "cs!modules/games/index/views"], (Hexa, Views) ->
  create = ->
    game    = Hexa.request "entities:game"
    planets = Hexa.request "entities:planets"

    game.save(planet: planets.first()).done ->
      Hexa.trigger "games:show", game

  index = (games) ->
    currentPlayer = Hexa.request("app:currentUser")


    gamesView = new Views.GamesView collection: games.started(), currentPlayer: currentPlayer
    Hexa.mainRegion.show gamesView

    gamesView.on "game:new", ->
      create()

    gamesView.on "game:show", (view) ->
      Hexa.trigger "games:show", view.model.id

  # EXPORTS

  index: ->
    if (games = Hexa.request "entities:games").isEmpty() then create() else index(games)

  new: ->
    create()
