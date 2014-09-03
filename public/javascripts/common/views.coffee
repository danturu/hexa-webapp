define ["cs!app", "text!common/templates.html", "marionette", "cs!lib/facebook", "jquery"], (Hexa, TEMPLATES, Marionette, Facebook, $) ->
  class LoadingView extends Marionette.ItemView
    template  : [TEMPLATES, "loading"]
    className : "loading"

  class FacebookLoginView extends Marionette.ItemView
    template  : [TEMPLATES, "facebook-login"]
    tagName   : "section"
    className : "facebook-login"

    events:
      "click a.login" : "login"

    triggers:
      "click a.menu" : "go:menu"

    login: (event) ->
      event.preventDefault()

      Facebook.login (loggedIn) =>
        if loggedIn
          @trigger "login:success"
        else
          @trigger "login:fail"

  # EXPORTS

  LoadingView       : LoadingView
  FacebookLoginView : FacebookLoginView
