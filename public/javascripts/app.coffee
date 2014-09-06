define ["marionette", "jquery", "underscore", "effect-fade", "effect-toggle"], (Marionette, $, _) ->
  Hexa = new Marionette.Application()

  Hexa.addRegions mainRegion: "main"
  Hexa.mainRegion.top    = -> @.$el.removeClass "center"; @
  Hexa.mainRegion.center = -> @.$el.addClass    "center"; @

  Hexa.on "before:start", (bootstrapData) ->
    Hexa.entitiesCache = {}
    Hexa.bootstrapData = bootstrapData
    Hexa.currentModule = stop: ->

  Hexa.on "start", ->
    Backbone.history.start pushState: true unless Backbone.history.started

  Hexa.startModule = (moduleName, attributes...) ->
    return if Hexa.currentModule.moduleName is moduleName

    # Call current finalizers.

    Hexa.currentModule.stop()

    # Start a new one module with custom attributes.

    (Hexa.currentModule = Hexa.module moduleName).start(attributes)

  Hexa.navigate = (route, options={}) ->
    Backbone.history.navigate route, options

  Hexa.currentRoute = ->
    Backbone.history.fragment

  Hexa.flash = (message, options={}) ->
    $flash  = $("section.flash")
    options = $.extend(type: "notice", effect: "slide", direction: "up", duration: "fast", timeout: 4000, options)

    # Setup HTML attributes, flash type and message text.

    $flash.removeClass().addClass("flash #{options.type}").data("options", options).html(message)

    # Show the flash for a specified time.

    $flash.show(options.effect, options, options.duration).timer(options.timeout, Hexa.hideFlash)

  Hexa.hideFlash = ->
    $flash  = $("section.flash")
    options = $flash.data("options")

    $flash.hide(options.effect, options, options.duration)

  # EXPORTS

  Hexa
