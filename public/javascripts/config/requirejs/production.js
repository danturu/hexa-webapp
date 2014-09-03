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
    "facebook": "../../tmp/public/javascripts/facebook/index",
    "humps": "../../tmp/public/javascripts/humps/humps",
    "jquery": "../../tmp/public/javascripts/jquery/dist/jquery",
    "jquery.timeago": "../../tmp/public/javascripts/jquery-timeago/jquery.timeago",
    "marionette": "../../tmp/public/javascripts/marionette/lib/core/backbone.marionette",
    "modernizr": "../../tmp/public/javascripts/modernizr/modernizr.build",
    "text": "../../tmp/public/javascripts/requirejs-text/text",
    "underscore": "../../tmp/public/javascripts/underscore/underscore"
  },

  shim: {
    "humps": {
      exports: "humps"
    },

    "facebook": {
      exports: "FB"
    }
  },

  exclude: [
    "coffee-script"
  ],

  stubModules: [
    "cs", "text"
  ]
});

