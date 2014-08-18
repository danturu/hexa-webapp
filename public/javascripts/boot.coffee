require ["cs!app", "cs!config/environment", "jquery", "cs!modules/games/mod"], (Hexa, Environment, $) ->
  data = JSON.parse $("#data").text()
  Hexa.start data
