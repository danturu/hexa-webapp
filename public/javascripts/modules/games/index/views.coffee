define ["text!modules/games/index/templates.html", "marionette"], (TEMPLATES, Marionette) ->
  class GameView extends Marionette.ItemView
    template  : [TEMPLATES, "game"]
    tagName   : "li"
    className : "game"

    triggers:
      "click a" : "show"

    serializeData: ->
      id    : @model.id
      name  : @opponent.name()
      state : @state()
      score : @score()

    initialize: (options) ->
      @opponent = @model.opponentFor options.currentPlayer

    onRender: ->
      @.$("div.avatar").css "background-image" : "url(#{@opponent.avatarUrl()})"

    state: ->
      if @model.state() is "finished"
        "Finished"
      else
        if @model.turnOf @opponent
          "Opponent turn"
        else
          "Your turn"

    score: ->
      "7:23"

  class GamesView extends Marionette.CompositeView
    template             : [TEMPLATES, "games"]
    tagName              : "article"
    className            : "games"
    childView            : GameView
    childViewContainer   : "ul"
    childViewEventPrefix : "game"

    triggers:
      "click a.new" : "game:new"

    childViewOptions: ->
      currentPlayer : @currentPlayer

    initialize: (options) ->
      @currentPlayer = options.currentPlayer

  # EXPORTS

  GamesView : GamesView
