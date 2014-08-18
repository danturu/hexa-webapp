define ["cs!app", "cs!modules/games/show/views", "cs!modules/games/show/utils", "cs!entities/game", "fabric", "underscore"], (Hexa, Views, Utils, Game, Fabric, _) ->
  fetch = (id) ->
    (game = Hexa.request("entities:game", id)).fetch().done -> show game

  wait = (game) ->

  show = (game) ->
    return wait game if game.noOpponent()

    currentPlayer = Hexa.request "app:currentUser"
    currentColor  = game.colorOf currentPlayer
    currentUnit   = undefined

    grid = new Utils.Grid game.w(), game.h(), Views.GameView.BASE_W, \
                                              Views.GameView.BASE_H, \
                                              Views.GameView.VIEW_S, 4

    gameView = new Views.GameView model: game.planet()
    Hexa.mainRegion.show gameView

    plotsView = new Views.PlotsView collection: game.plots(), grid: grid
    gameView.show plotsView

    unitsView = new Views.UnitsView collection: game.units(), grid: grid
    gameView.show unitsView

    plotsView.on "plot:click", (event) ->
      return unless event.model.state() in ["clone", "move"]

      currentPlot = event.model
      x = currentPlot.x()
      y = currentPlot.y()

      game.plots().state(null)

      # if event.model.state() is "clone"
      #   currentUnit.clone x, y
#
      # if event.model.state() is "jump"
      #   currentUnit.jump x, y
#
      # currentUnit.attack()

#      game.turn fromX: currentUnit.x(), fromY: currentUnit.y(), toX: currentPlot.x(), toY: currentPlot.y()

    unitsView.on "unit:click", (event) ->
#      return unless (game.turnOf currentPlayer) and (event.model.isColor currentColor)

      currentUnit = event.model
      x = currentUnit.x()
      y = currentUnit.y()

      game.plots().state("")
      game.plots().unoccupied(game.units(), grid.perimeter x, y, 0).state("active")
      game.plots().unoccupied(game.units(), grid.perimeter x, y, 1).state("clone")
      game.plots().unoccupied(game.units(), grid.perimeter x, y, 2).state("move")

      Fabric.redraw()

    # HANDLERS

    Fabric.on "canvas:redraw", _.throttle (-> gameView.canvas.renderAll()), 25

  show: (game) ->
    (if _.isString game then fetch else show)(game)

  join: (id) ->
    game = Hexa.request "entities:game", id
    game.join().done ->
      Hexa.request("app:currentUser").games().add game
      show game

