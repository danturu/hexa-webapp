express = require "express"
session = require "cookie-session"

# CONFIGURE

env  = process.env
port = env.PORT || 5000
app  = express()

app.use session secret: env.SESSION_SECRET
app.use "/assets", express.static __dirname + "/assets"

app.set "views", __dirname
app.set "view engine", "ejs"

# ENVIRONMENT

require("#{__dirname}/config/environments/#{app.settings.env}.coffee")(app, env, __dirname)
require("#{__dirname}/lib/authentication.coffee")(app, env, __dirname)

# ROUTES

app.get "/", (request, response) ->
  response.render "application"

app.listen port, ->
  console.log "Listening on port: #{port}"