define ["cs!app", "fabric", "backbone", "marionette", "humps", "jquery", "underscore"], (Hexa, Fabric, Backbone, Marionette, Humps, $, _) ->
  Hexa.ENDPOINT_URL = $("meta[name=hexa-endpoint-url]").attr "content"
  Hexa.ACCESS_TOKEN = $("meta[name=hexa-access-token]").attr "content"

  $(window).on "resize", (event) =>
    Backbone.trigger "window:resize", event unless $(event.target).hasClass("ui-resizable")

  $.ajaxPrefilter (options, originalOptions, xhr) =>
    xhr.setRequestHeader "Authorization", "Bearer #{Hexa.ACCESS_TOKEN}" if options.url.indexOf(Hexa.ENDPOINT_URL) isnt -1

  # backbone.js

  Backbone.customRequest = (context, options, params={}) ->
    Backbone.sync.call context, "request", @, _.defaults options, data: $.param(Humps.decamelizeKeys params)

  # marionette.js

  Marionette.Renderer.render = (template, data) ->
    return unless template

    html = _ $(template[0]).filter("[data-name=#{template[1]}]").html()

    throw "Template #{template[1]} not found!" if html.isEmpty()

    # interpolate...

    html.template data

  # fabric.js

  Fabric.Canvas::renderOnAddRemove  = false
  Fabric.Object::selectable         = false
  Fabric.Object::perPixelTargetFind = true
  Fabric.Object::originX            = "center"
  Fabric.Object::originY            = "center"

  # why fabric.js hasn't built-in event emitter?

  _.extend Fabric, Backbone.Events

  Fabric.redraw = -> Fabric.trigger "canvas:redraw"
