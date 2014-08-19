define ["marionette"], (Marionette) ->
  Hexa = new Marionette.Application()

  Hexa.addRegions mainRegion: "main"

  Hexa.on "before:start", (data) ->
    Hexa.entitiesCache = {}
    Hexa.bootstrapData = data
    Hexa.currentSubMod = stop: ->

  Hexa.on "start", ->
    return if Backbone.history.started

    Backbone.history.start pushState: true

    Hexa.trigger "games:index" if Hexa.currentRoute() is ""

  Hexa.startSubMod = (subModName, attributes...) ->
    return if Hexa.currentSubMod.moduleName is subModName

    Hexa.currentSubMod.stop()
    Hexa.currentSubMod = Hexa.module subModName
    Hexa.currentSubMod.start attributes

  Hexa.navigate = (route, options={}) ->
    Backbone.history.navigate route, options

  Hexa.currentRoute = ->
    Backbone.history.fragment

  # EXPORTS

  Hexa
