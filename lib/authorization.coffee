module.exports = (app, env, __root, API) ->
  oauth = require "oauth"
  humps = require "humps"

  mount: ->
    app.use (request, response, next) ->
      if request.session.accessToken or request.path.substring(0, 5) is "/auth"
        next()
      else
        response.redirect "/auth"

    app.use (request, response, next) ->
      response.locals.endpoint    = env.SERVER_ENDPOINT
      response.locals.accessToken = request.session.accessToken
      next()

    app.get "/auth", (request, response) ->
      response.redirect API.authorization.getAuthorizeUrl()

    app.get "/auth/callback", (request, response) ->
      API.authorization.getAccessToken request.query.code, (event, accessToken) ->
        request.session.accessToken = accessToken
        response.redirect "/"

    app.get "/logout", (request, response) ->
      request.session.accessToken = null
      response.redirect "/logout"