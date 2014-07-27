module.exports = (app, env, __root) ->
  oauth = require "oauth"
  humps = require "humps"
  Q     = require "q"

  master = new oauth.OAuth2 env.SERVER_PUBLIC_KEY, env.SERVER_SECRET_KEY, env.SERVER_ENDPOINT, "/oauth/authorize", "/oauth/token", null
  API    = master: master, authorization: {}, users: {}, objects: {}, games: {}

  API.get = (path, accessToken) ->
    master.get "#{env.SERVER_ENDPOINT}/api/v1/#{path}", accessToken, (event, data) -> deferred.resolve data

    deferred = new Q.defer()
    deferred.promise

  API.authorization.getAuthorizeUrl = ->
      options = humps.decamelizeKeys redirectUri: env.OAUTH_REDIRECT_URI, responseType: "code"
      hexaServer.getAuthorizeUrl options

  API.authorization.getAccessToken = (code, callback) ->
      options = humps.decamelizeKeys redirectUri: env.OAUTH_REDIRECT_URI, grantType: "authorization_code"
      hexaServer.getOAuthAccessToken code, options, callback

  API.users.current = (accessToken) ->
    API.get "users/current", accessToken

  API.objects.index = (accessToken) ->
    API.get "objects", accessToken

  # EXPORTS

  API