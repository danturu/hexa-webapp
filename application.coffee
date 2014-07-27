express = require "express"
session = require "cookie-session"
Q       = require "q"

# CONFIG

env  = process.env
port = env.PORT || 5000
app  = express()

app.use session secret: env.SESSION_SECRET
app.use "/assets", express.static __dirname + "/app/assets"

app.set "views", __dirname
app.set "view engine", "ejs"

# ENVIRONMENT

require("#{__dirname}/config/environments/#{app.settings.env}.coffee")(app, env, __dirname)

# MODULES

API           = require("#{__dirname}/lib/api.coffee")(app, env, __dirname)
authorization = require("#{__dirname}/lib/authorization.coffee")(app, env, __dirname, API)

# ROUTES

authorization.mount()

app.get "/", (request, response) ->
  accessToken = request.session.accessToken

  Q.all([API.users.current(accessToken), API.objects.index(accessToken)]).then (data) ->
    response.render "application", data: { user: data[0], objects: data[1] }

app.listen port, ->
  console.log "Listening on port: #{port}"