define ["cs!application", "cs!modules/games/index/controller", "underscore"], (Hexa, Controller, _) ->
  IndexMod = Hexa.module "GamesMod.Index"

  IndexMod.addInitializer ->
    alert "sdc"
    IndexMod.Controller = Controller

  IndexMod.addFinalizer ->
    IndexMod.Controller.close() if _.isFunction IndexMod.Controller.close

  # EXPORTS

  IndexMod
