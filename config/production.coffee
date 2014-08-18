module.exports = (app) ->
  express = require "express"

  # ASSETS

  app.use "/assets", express.static "#{app.get 'root'}/public/assets"
  app.use "/assets", express.static "#{app.get 'root'}/public/images"
  app.use "/assets", express.static "#{app.get 'root'}/public/fonts"

  map = require "#{app.get 'root'}/public/assets/map.json"

  javascriptTag = -> """
    <script src="/assets/#{map['application.js']}"></script>
  """

  stylesheetTag = -> """
    <link href="/assets/#{map['application.css']}" media="screen" rel="stylesheet" />
  """

  app.use (req, res, next) ->
    res.locals.javascriptTag = javascriptTag
    res.locals.stylesheetTag = stylesheetTag
    next()
