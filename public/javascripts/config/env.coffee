define ["cs!app", "cs!lib/messages", "fabric", "backbone", "marionette", "modernizr", "jquery", "underscore", "facebook", "humps"], (Hexa, Messages, Fabric, Backbone, Marionette, Modernizr, $, _) ->
  config = (name) -> $("meta[name=#{name}]").attr("content")

  Hexa.ENDPOINT_URL = config "hexa-endpoint-url"
  Hexa.ACCESS_TOKEN = config "hexa-access-token"
  Hexa.WS_URL       = config "hexa-ws-url"

  # jquery.js

  $(window).on "resize", (event) =>
    Backbone.trigger "window:resize", event unless $(event.target).hasClass("ui-resizable")

  $.ajaxPrefilter (options, originalOptions, xhr) =>
    xhr.setRequestHeader "Authorization", "Bearer #{Hexa.ACCESS_TOKEN}" if options.url.indexOf(Hexa.ENDPOINT_URL) isnt -1

  $.fn.timer = (timeout, callback, id="timer") ->
    $el = $ @
    clearTimeout $el.data(id); $el.data id, setTimeout(callback, Math.min timeout, 24 * 60 * 60 * 1000);

  # facebook.js

  FB.init appId: config("facebook-id"), version: "v2.1", status: true, cookie: true, frictionlessRequests: true

  # messages.js

  # backbone.js

  Backbone.customRequest = (context, options, params={}) ->
    Backbone.sync.call context, "request", @, _.defaults options, data: $.param(humps.decamelizeKeys params)

  # marionette.js

  Marionette.Renderer.render = (template, data) ->
    return unless template

    $html = _ $(template[0]).filter("[data-name=#{template[1]}]").html()

    if $html.isEmpty()
      throw "Template #{template[1]} not found!"
    else
      $html.template data

  # fabric.js

  Fabric.Canvas::renderOnAddRemove  = false
  Fabric.Object::selectable         = false
  Fabric.Object::perPixelTargetFind = true
  Fabric.Object::originX            = "center"
  Fabric.Object::originY            = "center"

  # why fabric.js hasn't built-in event emitter?

  _.extend Fabric, Backbone.Events

  Fabric.redraw = -> Fabric.trigger "canvas:redraw"
