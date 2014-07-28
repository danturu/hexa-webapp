define ["marionette"], (Marionette) ->
  Hexa = new Marionette.Application()

  Hexa.addRegions mainRegion: "article.app"

  Hexa.on "before:start", (data) ->
    Hexa.entitiesCache = {}
    Hexa.bootstrapData = data
    Hexa.currentSubMod = stop: ->

  Hexa.on "start", ->
    return if Backbone.history.started

    Backbone.history.start pushState: true
    Hexa.trigger "game:start"

  Hexa.startSubMod = (subModName, attributes...) ->
    return if Hexa.currentSubMod.moduleName is subModName

    Hexa.currentSubMod.stop()
    Hexa.currentSubMod = Hexa.module subModName
    Hexa.currentSubMod.start attributes

  # EXPORTS

  Hexa