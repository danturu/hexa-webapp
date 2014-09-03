define ["cs!app", "cs!modules/games/new/views", "cs!common/views", "cs!lib/facebook", "cs!entities/friend", "facebook"], (Hexa, Views, CommonViews, Facebook) ->
  create = (opponent) ->
    game    = Hexa.request "entities:game"
    planets = Hexa.request "entities:planets"

    game.save(planet: planets.first(), opponent: opponent).done ->
      data = { game_id: game.id, action_name: "invite" }

      Facebook.challenge "I challenge you to play Hexa Space with me!", to: opponent.id, data: data, (sent) ->
        if sent
          Hexa.trigger "games:show", game.id
        else
          game.destroy()

  show = ->
    Hexa.request "entities:friends", (friends) ->
      friendsView = new Views.FriendsView collection: friends
      Hexa.mainRegion.top().show friendsView

      friendsView.on "go:menu", (view) ->
        Hexa.trigger "games:index"

      friendsView.on "friend:invite", (view) ->
        create view.model

  login = ->
    facebookLoginView = new CommonViews.FacebookLoginView()
    Hexa.mainRegion.center().show facebookLoginView

    facebookLoginView.on "go:menu", ->
      Hexa.trigger "games:index"

    facebookLoginView.on "login:success", ->
       loadingView = new CommonViews.LoadingView()
       Hexa.mainRegion.center().show loadingView

       show()

    facebookLoginView.on "login:fail", ->
      Hexa.flash "Can't continue without Facebook login!"

  # EXPORTS

  show: ->
    loadingView = new CommonViews.LoadingView()
    Hexa.mainRegion.center().show loadingView

    Facebook.isLoggedIn (loggedIn) ->
      unless loggedIn
        login()
      else
        show()

