module.exports = (app) ->
  express = require "express"

  # ASSETS

  app.use "/assets", express.static "#{app.get 'root'}/public/assets"
  app.use "/assets", express.static "#{app.get 'root'}/public/images"
  app.use "/assets", express.static "#{app.get 'root'}/public/fonts"

  app.use (req, res, next) ->
    if /(.+)(\.)(.+)$/.test req.path
      res.status(404).send("Not Found")
    else
      next()

  map = require "#{app.get 'root'}/public/assets/map.json"

  javascriptTag = -> """
    <script src="/assets/#{map['application.js']}"></script>
  """

  stylesheetTag = -> """
    <link href="/assets/#{map['application.css']}" media="screen" rel="stylesheet" />
  """

  assetPath = (name) ->
    "/assets/#{map[name]}"

  app.use (req, res, next) ->
    res.locals.javascriptTag = javascriptTag
    res.locals.stylesheetTag = stylesheetTag
    res.locals.assetPath     = assetPath
    next()
