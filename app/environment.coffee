define ["cs!application", "jquery"], (Hexa, $) ->
  Environment =
    ENDPOINT     : $("meta[name=hexa-endpoint]").attr     "content"
    ACCESS_TOKEN : $("meta[name=hexa-access-token]").attr "content"

  Marionette.Renderer.render = (template, data) ->
    return if template is false

    html = _ $(template[0]).filter("[data-name=#{template[1]}]").html()

    throw "Template #{template[1]} not found!" if html.isEmpty()

    # interpolate...

    html.template data

  $(window).on "resize", (event) =>
    Backbone.trigger "window:resize", event unless $(event.target).hasClass("ui-resizable")

  $.ajaxPrefilter (options, originalOptions, xhr) =>
    xhr.setRequestHeader "Authorization", "Bearer #{Environment.TOKEN}" if options.url.indexOf(Environment.ENDPOINT) isnt -1

  # EXPORTS

  Environment