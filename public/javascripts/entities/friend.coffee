define ["cs!app", "backbone", "cs!lib/facebook"], (Hexa, Backbone, Facebook) ->
  class Model extends Backbone.Model
    name: ->
      @get("name")

    avatarUrl: ->
      @get("picture").data.url

    hasAvatar: ->
      !!!@get("picture").data.is_silhouette

  class Collection extends Backbone.Collection
    model: Model

    comparator: (friend) ->
      new String(friend.name()).toLowerCase()

  # HANDLERS

  Hexa.reqres.setHandler "entities:friends", (callback) ->
    requests = []
    requests.push Facebook.request "me/friends",           fields: "name, picture"
    requests.push Facebook.request "me/invitable_friends", fields: "name, picture"

    $.when(requests[0], requests[1]).then ->
      callback new Collection [].concat(arguments[0].data, arguments[1].data)

  # EXPORTS

  Model      : Model
  Collection : Collection

