module.exports = (app) ->
  express = require "express"
  sass    = require "node-sass"

  # ASSETS

  app.use "/assets", sass.middleware
    src       : "#{app.get 'root'}/public/stylesheets"
    dest      : "#{app.get 'root'}/tmp/public/stylesheets"
    imagePath : "/assets"
    force     : true
    debug     : true

  ["javascripts", "stylesheets", "images", "fonts"].forEach (dir) ->
    app.use "/assets", express.static "#{app.get 'root'}/public/#{dir}"
    app.use "/assets", express.static "#{app.get 'root'}/tmp/public/#{dir}"

  app.use (req, res, next) ->
    if /(.+)(\.)(.+)$/.test req.path
      res.status(404).send("Not Found")
    else
      next()

  # HELPERS

  javascriptTag = -> """
    <script src="/assets/requirejs/require.js"></script>
    <script>require(["/assets/config/requirejs/development.js"], function() { require(["cs!boot"]) });</script>
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
