express = require "express"
session = require "cookie-session"
Q       = require "q"
Hexa    = require "./lib/hexa"

env = process.env
app = express()

# CONFIG

app.set "hexa", hexa = new Hexa env.HEXA_PUBLIC_KEY, env.HEXA_SECRET_KEY, env.HEXA_ENDPOINT_URL, env.HEXA_REDIRECT_URL

app.use session secret: env.SESSION_SECRET

app.set "root",  __dirname
app.set "views", __dirname
app.set "view engine", "ejs"

require("./config/#{app.settings.env}.coffee")(app)

# ROUTES

app.use (req, res, next) ->
  if hexa.sign(req.session.accessToken) or req.path.substring(0, 5) is "/auth"
    res.locals.endpointUrl = hexa.endpointUrl
    res.locals.accessToken = hexa.accessToken

    next()
  else
    req.session.returnTo = req.path unless req.session.returnTo
    res.redirect hexa.getAuthorizeUrl()

app.get "/auth/callback", (req, res) ->
  hexa.getAccessToken req.query.code, (event, accessToken) ->
    returnTo = req.session.returnTo or "/"

    req.session.returnTo    = null
    req.session.accessToken = accessToken

    res.redirect returnTo

app.get "/logout", (req, res) ->
  req.session.returnTo    = null
  req.session.accessToken = null

  res.redirect hexa.getLogoutUrl()

app.get "/*", (req, res) ->
  resources = [
    hexa.get("users/current"), hexa.get("objects")
  ]

  Q.all(resources).then (data) ->
    res.render "app", data: { currentUser: data[0], objects: data[1] }

# EXPORTS

module.exports = app
