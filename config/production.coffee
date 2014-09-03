module.exports = (app) ->
  express = require "express"
  favicon = require "serve-favicon"

  # Trust to self-signed certificates.

  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

  # Force redirect to secure HTTP connection.

  app.use (req, res, next) ->
    if req.secure or req.headers["x-forwarded-proto"] is "https"
      next()
    else
      res.redirect ["https://", req.get("host"), req.url].join("")

  # ASSETS

  root = app.get "root"
  map  = require "#{root}/public/assets/map.json"

  app.use favicon "#{root}/public/assets/#{map["favicon.ico"]}"
  app.use "/assets", express.static "#{root}/public/assets"
  app.use "/assets", express.static "#{root}/public/images"
  app.use "/assets", express.static "#{root}/public/fonts"

  javascriptTag = -> """
    <script src="/assets/#{map["application.js"]}"></script>
  """

  stylesheetTag = -> """
    <link href="/assets/#{map["application.css"]}" media="screen" rel="stylesheet" />
  """

  assetPath = (name) ->
    "/assets/#{map[name]}"

  app.use (req, res, next) ->
    res.locals.javascriptTag = javascriptTag
    res.locals.stylesheetTag = stylesheetTag
    res.locals.assetPath     = assetPath
    next()
