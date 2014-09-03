express = require "express"
session = require "cookie-session"
Q       = require "q"
Hexa    = require "./lib/hexa"

env = process.env
app = express()

# CONFIG

app.set "hexa", hexa = new Hexa env.HEXA_PUBLIC_KEY, env.HEXA_SECRET_KEY, env.HEXA_ENDPOINT_URL, env.HEXA_REDIRECT_URL

app.use session secret: env.APP_SESSION_SECRET

app.set "root",  __dirname
app.set "views", __dirname
app.set "view engine", "ejs"

require("./config/#{app.settings.env}.coffee")(app)

# ROUTES

app.use (req, res, next) ->
  if /(.+)(\.)(.+)$/.test req.path
    res.status(404).send("Not Found")
  else
    next()

app.use (req, res, next) ->
  res.setHeader "X-Frame-Options", "ALLOW-FROM https://apps.facebook.com"

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
  res.locals.wsUrl      = env.WS_URL
  res.locals.facebookId = env.FACEBOOK_ID

  success = (data) ->
    res.render("app", data: { currentUser: data[0], objects: data[1] })

  fail = ->
    res.status(500).send("Server Error")

  resources = [
    hexa.get("users/current"), hexa.get("objects")
  ]

  Q.all(resources).then(success, fail)

# EXPORTS

module.exports = app
