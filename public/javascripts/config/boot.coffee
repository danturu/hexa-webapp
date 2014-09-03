require ["cs!app", "cs!config/env", "jquery", "cs!common/views", "cs!modules/games/mod"], (Hexa, Env, $) ->
  data = JSON.parse $("#data").text()
  Hexa.start data
