define ["cs!app", "cs!modules/games/new/controller", "underscore"], (Hexa, Controller, _) ->
  NewMod = Hexa.module "GamesMod.New"

  NewMod.addInitializer ->
    NewMod.Controller = Controller

  NewMod.addFinalizer ->
    NewMod.Controller.close() if _.isFunction NewMod.Controller.close

  # EXPORTS

  NewMod
