module.exports = (app, express, __root) ->
  express = require "express"
  sass    = require "node-sass"

  # ASSETS

  app.use "/assets/javascripts/vendor", express.static __root + "/vendor/javascripts/bower"
  app.use "/assets/javascripts",        express.static __root + "/app"

  app.get "/assets/application.css", (request, response) ->
    response.end sass.renderSync
      file         : __root + "/config/manifest.scss",
      includePaths : ["vendor/stylesheets", "app/assets/stylesheets"]

  # HELPERS

  javascriptTag = ->
    '<script src="/assets/javascripts/vendor/requirejs/require.js" data-main="assets/javascripts/boot"></script>'

  stylesheetTag = ->
    '<link href="/assets/application.css" media="screen" rel="stylesheet" />'

  app.use (request, response, next) ->
    response.locals.javascriptTag = javascriptTag
    response.locals.stylesheetTag = stylesheetTag
    next()