module.exports = (app) ->
  express = require "express"
  favicon = require "serve-favicon"
  sass    = require "node-sass"

  # Trust to self-signed certificates.

  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

  # ASSETS

  root = app.get "root"

  app.use favicon "#{root}/public/images/favicon.ico"

  app.use "/assets", sass.middleware
    src       : "#{root}/public/stylesheets"
    dest      : "#{root}/tmp/public/stylesheets"
    imagePath : "/assets"
    force     : true
    debug     : true

  ["javascripts", "stylesheets", "images", "fonts"].forEach (dir) ->
    app.use "/assets", express.static "#{root}/public/#{dir}"
    app.use "/assets", express.static "#{root}/tmp/public/#{dir}"

  # HELPERS

  javascriptTag = -> """
    <script src="/assets/requirejs/require.js"></script>

    <script>
      require(["/assets/config/requirejs/development.js"], function() {
        require(["cs!config/boot"])
      });
    </script>
  """

  stylesheetTag = -> """
    <link href="/assets/app.css" media="screen" rel="stylesheet" />
  """

  assetPath = (name) ->
    "/assets/#{name}"

  app.use (req, res, next) ->
    res.locals.javascriptTag = javascriptTag
    res.locals.stylesheetTag = stylesheetTag
    res.locals.assetPath     = assetPath
    next()
