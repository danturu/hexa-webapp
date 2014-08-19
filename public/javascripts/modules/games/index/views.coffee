define ["text!modules/games/index/templates.html", "marionette"], (TEMPLATES, Marionette) ->
  class GameView extends Marionette.ItemView
    template  : [TEMPLATES, "game"]
    tagName   : "li"
    className : "game"

    triggers:
      "click a" : "show"

    serializeData: ->
      id       : @model.id
      turn     : @turn()
      opponent : @opponent.name()
      score    : @score()

    initialize: (options) ->
      @player   =                    options.player
      @opponent = @model.opponentFor options.player

    onRender: ->
      @.$("div.avatar").css "background-image" : "url(#{@opponent.avatarUrl()})"

    turn: ->
      if @model.turnOf @player then "Your Turn" else "Opponent Turn"

    score: ->
      @model.scoreFor @player

  class GamesView extends Marionette.CompositeView
    template             : [TEMPLATES, "games"]
    tagName              : "article"
    className            : "games"
    childView            : GameView
    childViewContainer   : "ul"
    childViewEventPrefix : "game"

    triggers:
      "click a.new"  : "game:new"
      "click a.join" : "game:join"

    initialize: (options) ->
      @childViewOptions = player: options.player

  # EXPORTS

  GamesView : GamesView
