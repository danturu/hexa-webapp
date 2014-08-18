require.config({
  paths: {
    "almond": "../../tmp/public/javascripts/almond/almond",
    "async": "../../tmp/public/javascripts/async/lib/async",
    "backbone": "../../tmp/public/javascripts/backbone/backbone",
    "backbone.babysitter": "../../tmp/public/javascripts/backbone.babysitter/lib/backbone.babysitter",
    "backbone.relational": "../../tmp/public/javascripts/backbone-relational/backbone-relational",
    "backbone.routefilter": "../../tmp/public/javascripts/routefilter/dist/backbone.routefilter",
    "backbone.wreqr": "../../tmp/public/javascripts/backbone.wreqr/lib/backbone.wreqr",
    "coffee-script": "../../tmp/public/javascripts/coffeescript/extras/coffee-script",
    "cs": "../../tmp/public/javascripts/require-cs/cs",
    "fabric": "../../tmp/public/javascripts/fabric/dist/fabric.require",
    "humps": "../../tmp/public/javascripts/humps/humps",
    "jquery": "../../tmp/public/javascripts/jquery/dist/jquery",
    "marionette": "../../tmp/public/javascripts/marionette/lib/core/backbone.marionette",
    "text": "../../tmp/public/javascripts/requirejs-text/text",
    "underscore": "../../tmp/public/javascripts/underscore/underscore"
  },

  exclude: [
    "coffee-script"
  ],

  stubModules: [
    "cs", "text"
  ],
});
