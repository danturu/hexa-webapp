define ["cs!app", "cs!modules/games/index/views", "facebook"], (Hexa, Views, FB) ->
  show = ->
    player = Hexa.request "app:currentUser"
    games  = Hexa.request "entities:games"

    gamesView = new Views.GamesView collection: games.active(), player: player
    Hexa.mainRegion.center().show gamesView

    gamesView.on "game:new", ->
      Hexa.trigger "games:new"

    gamesView.on "game:join", ->
      Hexa.flash "We're working on getting this feature as soon as we can!"

    gamesView.on "game:show", (view) ->
      Hexa.trigger "games:show", view.model.id

    gamesView.on "game:leave", (view) ->
      view.model.destroy()

  # EXPORTS

  show: ->
    show()
