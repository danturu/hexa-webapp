define ["marionette", "jquery", "underscore"], (Marionette, $, _) ->
  Hexa = new Marionette.Application()

  Hexa.addRegions mainRegion: "main"
  Hexa.mainRegion.top    = -> @.$el.removeClass "center"; @
  Hexa.mainRegion.center = -> @.$el.addClass    "center"; @

  Hexa.on "before:start", (bootstrapData) ->
    Hexa.entitiesCache = {}
    Hexa.bootstrapData = bootstrapData
    Hexa.currentModule = stop: ->
    Hexa.$notice       = $("div.notice")

  Hexa.on "start", ->
    Backbone.history.start pushState: true unless Backbone.history.started

  Hexa.startModule = (moduleName, attributes...) ->
    return if Hexa.currentModule.moduleName is moduleName

    Hexa.currentModule.stop()
    Hexa.currentModule = Hexa.module moduleName
    Hexa.currentModule.start attributes

  Hexa.navigate = (route, options={}) ->
    Backbone.history.navigate route, options

  Hexa.currentRoute = ->
    Backbone.history.fragment

  Hexa.flash = (message, timeout=4000) ->
    timeout = Math.min timeout, 24 * 60 * 60 * 1000

    Hexa.$notice.html(message).removeClass("init").addClass("active")
    Hexa.$notice.timer(timeout, -> Hexa.$notice.removeClass "active")

  Hexa.hideFlash = ->
    Hexa.$notice.removeClass "active"

  # EXPORTS

  Hexa
