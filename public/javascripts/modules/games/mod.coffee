define ["cs!app", "cs!modules/games/controller", "underscore", "cs!modules/games/index/submod", "cs!modules/games/new/submod", "cs!modules/games/show/submod"], (Hexa, Controller, _) ->
  GamesMod = Hexa.module "GamesMod", startWithParent: false

  Hexa.addInitializer ->
    GamesMod.controller = new Controller GamesMod
    GamesMod.router     = new Controller.Router controller: GamesMod.controller

  Hexa.on "games:index games:new games:show", ->
    Hexa.startModule "GamesMod"

  Hexa.on "games:index", ->
    GamesMod.controller.index()
    Hexa.navigate "/"

  Hexa.on "games:new", ->
    GamesMod.controller.new()
    Hexa.navigate "/new"

  Hexa.on "games:show", (id) ->
    GamesMod.controller.show id
    Hexa.navigate "/#{id}"

  # EXPORTS

  GamesMod
