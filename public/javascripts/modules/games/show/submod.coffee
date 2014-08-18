define ["cs!app", "cs!modules/games/show/controller", "underscore"], (Hexa, Controller, _) ->
  ShowMod = Hexa.module "GamesMod.Show"

  ShowMod.addInitializer ->
    ShowMod.Controller = Controller

  ShowMod.addFinalizer ->
    ShowMod.Controller.close() if _.isFunction ShowMod.Controller.close

  # EXPORTS

  ShowMod
