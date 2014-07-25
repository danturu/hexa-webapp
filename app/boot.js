require.config({
  baseUrl: "/assets/javascripts",

  paths: {
    "coffee-script"       : "vendor/coffeescript/extras/coffee-script",
    "cs"                  : "vendor/require-cs/cs",
    "text"                : "vendor/requirejs-text/text",
    "jquery"              : "vendor/jquery/dist/jquery",
    "underscore"          : "vendor/underscore/underscore",
    "backbone"            : "vendor/backbone/backbone",
    "backbone.relational" : "vendor/backbone-relational/backbone-relational",
    "backbone.wreqr"      : "vendor/backbone.wreqr/lib/backbone.wreqr",
    "backbone.babysitter" : "vendor/backbone.babysitter/lib/backbone.babysitter",
    "marionette"          : "vendor/marionette/lib/core/backbone.marionette",
    "fabric"              : "vendor/fabric/dist/fabric.require",
    "jplayer"             : "vendor/jplayer/jquery.jplayer/jquery.jplayer"
  }
});

require(["cs!application", "jquery", "cs!environment",  "cs!modules/game/module", "cs!lib/array"], function(Hexa, $) {
  data = JSON.parse($("#data").text());
  Hexa.start(data);
});