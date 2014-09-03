define ["cs!app", "cs!modules/games/show/views", "cs!modules/games/show/utils", "cs!entities/game", "cs!entities/cell", "fabric", "underscore"], (Hexa, Views, Utils, Game, Cell, Fabric, _) ->
  show = (game) ->
    currentPlayer = Hexa.request "app:currentUser"
    currentColor  = if game.whitePlayer() is currentPlayer then "white" else "black"
    currentUnit   = undefined

    players = new Backbone.Collection([
      currentPlayer, game.opponentFor(currentPlayer)
    ])

    gameView = new Views.GameView model: game, collection: players
    Hexa.mainRegion.show gameView

    gameView.on "destroy", ->
      Hexa.hideFlash()

    gameView.on "exit", (event) ->
      Hexa.trigger "games:index"

    # CANVAS

    grid = new Utils.Grid game.w(), game.h(), Views.GameView.BASE_W, \
                                              Views.GameView.BASE_H, \
                                              Views.GameView.VIEW_S, 4

    plotsView = new Views.PlotsView collection: game.plots(), grid: grid
    gameView.show plotsView

    unitsView = new Views.UnitsView collection: game.units(), grid: grid
    gameView.show unitsView

    plotsView.on "plot:click", (event) ->
      return if game.state() isnt "playing"
      return unless event.model.getState() in ["clone", "move"]

      currentPlot = event.model
      x = currentPlot.x()
      y = currentPlot.y()
      old_x = currentUnit.x()
      old_y = currentUnit.y()


      attackUnit = null
      if event.model.getState() is "clone"
        attrs =  _.extend(_.omit(currentUnit.attributes, "id"), x: x, y:y)
        cloneUnit = new Cell.UnitModel(attrs)
        game.units().add cloneUnit
        attackUnit = cloneUnit

      if event.model.getState() is "move"
        currentUnit.move x, y
        console.log(x+ " " +y)
        attackUnit = currentUnit

      # attack

      enemies =  game.units().enemyFor(attackUnit, grid.perimeter(attackUnit.x(), attackUnit.y(), 1))

      _.each enemies.toArray(),(u) ->
        attrs =  _.extend(_.omit(currentUnit.attributes, "id"), x: u.x(), y:u.y())
        cloneUnit2 = new Cell.UnitModel(attrs)
        game.units().add cloneUnit2 , silent: true

        u.on "fabric:ddestroy", ->
          game.units().trigger "add", cloneUnit2

        u.destroy()

      game.plots().state("")
      #send to server

      game.turn fromX: old_x, fromY: old_y, toX: currentPlot.x(), toY: currentPlot.y()
      currentUnit = null

    unitsView.on "unit:click", (event) ->
      return if game.state() isnt "playing"
      return unless (game.canTurn currentPlayer) and (event.model.isColor currentColor)

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

  show: (id) ->
    currentPlayer = Hexa.request "app:currentUser"
    (game = Hexa.request "entities:game", id).fetch().done ->
      if game.state() is "waiting"
        Hexa.flash "Game will start after opponent joining... Wait...", Infinity

      if game.state() is "playing" and !game.canTurn(currentPlayer)
        Hexa.flash "Opponent turn... Wait...", Infinity

      show game

#    FB.ui {
#      method: 'apprequests',
#      message: 'Just smashed you 78 times! It\'s your turn.',
#      to: game.opponentFor(player).get("uid")
#      action_type:'turn'
#    }, (response) ->
#      console.log(response);

#canvasView = new Views.CanvasView model: game
#    gameView.mainRegion.show canvasView


# return wait game if game.noOpponent()
#
#
#    currentPlayer = Hexa.request "app:currentUser"
#    currentColor  = game.colorOf currentPlayer
#    currentUnit   = undefined
#
#    grid = new Utils.Grid game.w(), game.h(), Views.GameView.BASE_W, \
#                                              Views.GameView.BASE_H, \
#                                              Views.GameView.VIEW_S, 4
#
#    gameView = new Views.GameView model: game.planet()
#    Hexa.mainRegion.show gameView
#    return
#    plotsView = new Views.PlotsView collection: game.plots(), grid: grid
#    gameView.show plotsView
#
#    unitsView = new Views.UnitsView collection: game.units(), grid: grid
#    gameView.show unitsView
#
#    plotsView.on "plot:click", (event) ->
#      return unless event.model.state() in ["clone", "move"]
#
#      currentPlot = event.model
#      x = currentPlot.x()
#      y = currentPlot.y()
#
#      game.plots().state(null)
#
#      # if event.model.state() is "clone"
#      #   currentUnit.clone x, y
#
#      # if event.model.state() is "jump"
#      #   currentUnit.jump x, y
#
#      # currentUnit.attack()
#
#      game.turn fromX: currentUnit.x(), fromY: currentUnit.y(), toX: currentPlot.x(), toY: currentPlot.y()
#
#    unitsView.on "unit:click", (event) ->
#      return unless (game.turnOf currentPlayer) and (event.model.isColor currentColor)
#
#      currentUnit = event.model
#      x = currentUnit.x()
#      y = currentUnit.y()
#
#      game.plots().state("")
#      game.plots().unoccupied(game.units(), grid.perimeter x, y, 0).state("active")
#      game.plots().unoccupied(game.units(), grid.perimeter x, y, 1).state("clone")
#      game.plots().unoccupied(game.units(), grid.perimeter x, y, 2).state("move")
#
#      Fabric.redraw()
#
#    # HANDLERS
#
#    Fabric.on "canvas:redraw", _.throttle (-> gameView.canvas.renderAll()), 25
#
#
