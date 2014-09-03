define ["text!modules/games/new/templates.html", "marionette", "jquery"], (TEMPLATES, Marionette, $) ->
  class NoFriendsView extends Marionette.ItemView
    template  : [TEMPLATES, "no-friends"]
    className : "no-friends"

  class FriendView extends Marionette.ItemView
    template  : [TEMPLATES, "friend"]
    tagName   : "li"
    className : "friend"

    triggers:
      "click a" : "invite"

    onRender: ->
      @.$("div.avatar").css "background-image" : "url(#{@model.avatarUrl()})" if @model.hasAvatar()

  class FriendsView extends Marionette.CompositeView
    template             : [TEMPLATES, "friends"]
    tagName              : "article"
    className            : "friends"
    emptyView            : NoFriendsView
    childView            : FriendView
    childViewContainer   : "ul"
    childViewEventPrefix : "friend"

    ui:
      "search" : "input[type=search]"

    triggers:
      "click a.menu" : "go:menu"

    events:
      "keyup @ui.search" : "_renderChildren"

    addChild: (child, ChildView, index) ->
      super if @_matchCriteria child

    _renderChildren: ->
      @criteria = ///\b#{@ui.search.val()}///gi

      if @collection.some @_matchCriteria.bind(@)
        super
      else
        Marionette.CollectionView::destroyEmptyView.call @
        Marionette.CollectionView::destroyChildren.call  @
        Marionette.CollectionView::showEmptyView.call    @

    _matchCriteria: (child) ->
      child.name().match @criteria

  # EXPORTS

  FriendsView : FriendsView
