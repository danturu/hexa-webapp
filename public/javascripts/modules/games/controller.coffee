define ["cs!app", "marionette", "backbone.routefilter"], (Hexa, Marionette) ->
  class Controller extends Marionette.Controller
    constructor: (mod) ->
      @mod = mod; super;

    index: ->
      @mod.Index.Controller.index()

    new: ->
      @mod.Index.Controller.new()

    join: (id) ->
      @mod.Show.Controller.join id

    show: (id) ->
      @mod.Show.Controller.show id

  class Controller.Router extends Marionette.AppRouter
    appRoutes:
      "games"          : "index"
      "games/new"      : "new"
      "games/:id/join" : "join"
      "games/:id"      : "show"

    before: ->
      Hexa.startSubMod "GamesMod"

  # EXPORTS

  Controller
