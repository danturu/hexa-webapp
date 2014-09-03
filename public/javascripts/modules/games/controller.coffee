define ["cs!app", "marionette", "backbone.routefilter"], (Hexa, Marionette) ->
  class Controller extends Marionette.Controller
    constructor: (mod) ->
      @mod = mod; super;

    index: ->
      @mod.Index.Controller.show()

    new: ->
      @mod.New.Controller.show()

    show: (id) ->
      @mod.Show.Controller.show id

  class Controller.Router extends Marionette.AppRouter
    appRoutes:
      ""    : "index"
      "menu"    : "index"
      "new" : "new"
      ":id" : "show"

    before: ->
      Hexa.startModule "GamesMod"

  # EXPORTS

  Controller
