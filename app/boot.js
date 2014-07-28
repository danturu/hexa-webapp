require.config({
  baseUrl: "/assets/javascripts",

  paths: {
    "coffee-script"        : "vendor/coffeescript/extras/coffee-script",
    "cs"                   : "vendor/require-cs/cs",
    "text"                 : "vendor/requirejs-text/text",
    "jquery"               : "vendor/jquery/dist/jquery",
    "underscore"           : "vendor/underscore/underscore",
    "backbone"             : "vendor/backbone/backbone",
    "backbone.relational"  : "vendor/backbone-relational/backbone-relational",
    "backbone.wreqr"       : "vendor/backbone.wreqr/lib/backbone.wreqr",
    "backbone.babysitter"  : "vendor/backbone.babysitter/lib/backbone.babysitter",
    "backbone.routefilter" : "vendor/routefilter/dist/backbone.routefilter",
    "marionette"           : "vendor/marionette/lib/core/backbone.marionette",
    "fabric"               : "vendor/fabric/dist/fabric.require",
    "jplayer"              : "vendor/jplayer/jquery.jplayer/jquery.jplayer"
  }
});

var entities = [
  "cs!entities/planet",
  "cs!entities/user",
  "cs!entities/game",
  "cs!entities/plot",
  "cs!entities/unit",
  "cs!entities/cell",
]

var modules = [
  "cs!modules/games/mod",
]

require(["cs!application", "cs!environment", "jquery"].concat(entities, modules), function(Hexa, Environment, $) {
  data = JSON.parse($("#data").text());
  Hexa.start(data);
});