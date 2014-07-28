SubMods = [
  "cs!modules/games/index/submod", "cs!modules/games/show/submod"
]

define ["cs!application", "cs!modules/games/controller"].concat(SubMods), (Hexa, Controller) ->
  GamesMod = Hexa.module "GamesMod", startWithParent: false

  Hexa.addInitializer ->
    GamesMod.controller = new Controller GamesMod
    GamesMod.router     = new Controller.Router controller: GamesMod.controller

  Hexa.on "games:index", ->
    GamesMod.controller.index(); Hexa.navigate "/games";

  Hexa.on "games:show", (id) ->
    GamesMod.controller.show id; Hexa.navigate "/games/#{id}";

  # EXPORTS

  GamesMod