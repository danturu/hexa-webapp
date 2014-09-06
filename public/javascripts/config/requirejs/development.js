require.config({
  baseUrl: "/assets",

  paths: {
    "async": "async/lib/async",
    "backbone": "backbone/backbone",
    "backbone.babysitter": "backbone.babysitter/lib/backbone.babysitter",
    "backbone.relational": "backbone-relational/backbone-relational",
    "backbone.routefilter": "routefilter/dist/backbone.routefilter",
    "backbone.wreqr": "backbone.wreqr/lib/backbone.wreqr",
    "coffee-script": "coffeescript/extras/coffee-script",
    "cs": "require-cs/cs",
    "effect": "jquery-ui/ui/effect",
    "effect-fade": "jquery-ui/ui/effect-fade",
    "effect-toggle": "jquery-ui/ui/effect-slide",
    "fabric": "fabric/dist/fabric.require",
    "facebook": "facebook/index",
    "humps": "humps/humps",
    "jquery": "jquery/dist/jquery",
    "jquery.timeago": "jquery-timeago/jquery.timeago",
    "marionette": "marionette/lib/core/backbone.marionette",
    "modernizr": "modernizr/modernizr",
    "text": "requirejs-text/text",
    "underscore": "underscore/underscore"
  },

  shim: {
    "facebook": {
      exports: "FB"
    },

    "humps": {
      exports: "humps"
    }
  }
});
