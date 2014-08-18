define ["cs!app", "cs!modules/games/index/controller", "underscore"], (Hexa, Controller, _) ->
  IndexMod = Hexa.module "GamesMod.Index"

  IndexMod.addInitializer ->
    IndexMod.Controller = Controller

  IndexMod.addFinalizer ->
    IndexMod.Controller.close() if _.isFunction IndexMod.Controller.close

  # EXPORTS

  IndexMod
