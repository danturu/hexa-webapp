module.exports = (app, env, __root) ->
  oauth = require "oauth"
  humps = require "humps"

  app.use (request, response, next) ->
    if request.session.accessToken or request.path.substring(0, 5) == "/auth"
      next()
    else
      response.redirect "/auth"

  # Instance to work with Hexa Server.

  hexa = new oauth.OAuth2 env.SERVER_PUBLIC_KEY, env.SERVER_SECRET_KEY, env.SERVER_ENDPOINT, "/oauth/authorize", "/oauth/token", null

  app.use (request, response, next) ->
    response.locals.endpoint    = env.SERVER_ENDPOINT
    response.locals.accessToken = request.session.accessToken
    next()

  # Boilerplate authentication handlers.

  app.get "/auth", (request, response) ->
    options = humps.decamelizeKeys redirectUri: env.OAUTH_REDIRECT_URI, responseType: "code"
    response.redirect hexa.getAuthorizeUrl options

  app.get "/auth/callback", (request, response) ->
    options = humps.decamelizeKeys grantType: "client_credentials"

    hexa.getOAuthAccessToken request.query.code, options, (event, accessToken) ->
      request.session.accessToken = accessToken
      response.redirect "/"

  app.get "/logout", (request, response) ->
    request.session.accessToken = null
    response.redirect env.SERVER_ENDPOINT + "/logout"

  # EXPORTS

  hexa