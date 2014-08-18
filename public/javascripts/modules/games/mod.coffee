define ["cs!app", "cs!modules/games/controller", "underscore", "cs!modules/games/index/submod", "cs!modules/games/show/submod"], (Hexa, Controller, _) ->
  GamesMod = Hexa.module "GamesMod", startWithParent: false

  Hexa.addInitializer ->
    GamesMod.controller = new Controller GamesMod
    GamesMod.router     = new Controller.Router controller: GamesMod.controller

  Hexa.on "games:index games:show", ->
    Hexa.startSubMod "GamesMod"

  Hexa.on "games:index", ->
    GamesMod.controller.index()
    Hexa.navigate "/games"

  Hexa.on "games:show", (game) ->
    GamesMod.controller.show game
    Hexa.navigate "/games/#{if _.isString game then game else game.id}";

  # EXPORTS

  GamesMod
