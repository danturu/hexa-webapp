define ["text!modules/games/index/templates.html", "marionette", "jquery", "jquery.timeago"], (TEMPLATES, Marionette, $) ->
  class GameView extends Marionette.ItemView
    template  : [TEMPLATES, "game"]
    tagName   : "li"
    className : "game"

    triggers:
      "click a.show"  : "show"
      "click a.leave" : "leave"

    serializeData: ->
      id        : @model.id
      opponent  : @opponent.name()
      state     : @state()
      lastEvent : @lastEvent()
      score     : @score()

    initialize: (options) ->
      @player   =                    options.player
      @opponent = @model.opponentFor options.player

    onRender: ->
      @.$("div.avatar").css "background-image" : "url(#{@opponent.avatarUrl()})" if @opponent.hasAvatar()

    remove: ->
      @.$el.addClass("removing").timer(750, Marionette.View::remove.bind @)

    state: ->
      switch @model.state()
        when "waiting"
          "Waiting Opponent"
        when "playing"
          if @model.canTurn @player
            "Your Turn"
          else
            "Opponent Turn"

    lastEvent: ->
      eventName = switch @model.eventName()
        when "invite"
          "Invitation Send"
        when "start"
          "Opponent Joined"
        when "turn"
          "Last Turn"
        when "teave"
          "Opponent Leave"
        when "finish"
          "Game Over"

      "#{eventName} #{$.timeago @model.eventTime()}"

    score: ->
      @model.scoreFor(@player).join(":")

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
