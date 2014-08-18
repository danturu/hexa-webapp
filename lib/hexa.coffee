OAuth = require "oauth"
Humps = require "humps"
Q     = require "q"

class Hexa
  constructor: (publicKey, secretKey, endpointUrl, redirectUrl) ->
    @endpointUrl = endpointUrl
    @redirectUrl = redirectUrl

    @master = new OAuth.OAuth2 publicKey, secretKey, endpointUrl, "/oauth/authorize", "/oauth/token", null

  getAuthorizeUrl: ->
    options = Humps.decamelizeKeys redirectUri: @redirectUrl, responseType: "code"
    @master.getAuthorizeUrl options

  getLogoutUrl: ->
    "#{@endpointUrl}/logout"

  getAccessToken: (code, callback) ->
    options = Humps.decamelizeKeys redirectUri: @redirectUrl, grantType: "authorization_code"
    @master.getOAuthAccessToken code, options, callback

  sign: (accessToken) ->
    !!(@accessToken = accessToken)

  get: (resource) ->
    @master.get "#{@endpointUrl}/api/v1/#{resource}", @accessToken, (event, data) -> deferred.resolve JSON.parse data

    deferred = new Q.defer()
    deferred.promise

# EXPORTS

module.exports = Hexa
