define ["cs!application", "marionette", "backbone.routefilter"], (Hexa, Marionette) ->
  class Controller extends Marionette.Controller
    constructor: (mod) ->
      @mod = mod; super;

    index: ->
      @mod.Index.Controller.open()

    show: (id) ->
      @mod.Show.Controller.open id

  class Controller.Router extends Marionette.AppRouter
    appRoutes:
      "games"     : "index"
      "games/:id" : "show"

    before: ->
      Hexa.startSubMod "GamesMod"

  # EXPORTS

  Controller