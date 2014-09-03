define ["cs!lib/fabric/cache", "fabric", "underscore"], (Cache, Fabric, _) ->
  Fabric.Sprite = Fabric.util.createClass Fabric.Image,
    type : "sprite"

    initialize: (options={}) ->
      @callSuper "initialize", null, options

      # Hash with cached sprites, eg a object animation when the mouse over it
      # or animation the moment object being clicked, etc...

      @sprites = {}
      @tag     = ""

    putImage: (tag, image, spriteW, spriteH) ->
      image.cid ||= _.uniqueId "image"

      @sprites[tag] = sprites: (@_createSprites image, spriteW, spriteH), w: spriteW, h: spriteH

      @setTag tag if tag == @tag

    setTag: (tag, index=0) ->
      @tag    = tag
      @index  = index
      @width  = @sprites[@tag].w
      @height = @sprites[@tag].h

      # Renew corner position coordinates based on current sprite dimension.

      @setCoords()

    play: (options, callback=->) ->
      options = _.defaults options, duration: 300, repeat: 1, callback: callback

      @stop(); @setTag(options.tag);

      @playing = true

      @_timer = setInterval (=> @_nextFrame options), (@_getInterval options)

    stop: (userEvent=true) ->
      clearInterval @_timer

      @playing = false

      if userEvent
        @trigger "animation:abort"
      else
        @trigger "animation:end"

    isAnimating: ->
      @playing

    _createSprites: (image, spriteW, spriteH) ->
      spriteCount = parseInt image.width / spriteW

      [0...spriteCount].map (i) => @_createSprite i, image, spriteW, spriteH

    _createSprite: (i, image, spriteW, spriteH) ->
      return Cache.get cacheKey if Cache.has cacheKey = image.cid + i

      @tempCanvas  ||= Fabric.util.createCanvasElement()
      @tempCanvas.width  = spriteW
      @tempCanvas.height = spriteH

      @tempContext ||= @tempCanvas.getContext("2d")
      @tempContext.clearRect 0, 0, spriteW, spriteH
      @tempContext.drawImage image, -i * spriteW, 0

      sprite     = Fabric.util.createImage()
      sprite.src = @tempCanvas.toDataURL "image/png"

      Cache.put cacheKey, sprite

    _nextFrame: (options) ->
      if options.repeat <= 1 and @_isLastSprite()
        @stop(false)
        options.callback()
        return

      if @_isLastSprite()
        @index = 0; options.repeat--; @trigger "animation:cycle", options.repeat;
      else
        @index++

      Fabric.redraw()

    _getInterval: (options) ->
      options.duration / @sprites[@tag].sprites.length

    _sprite: ->
      @sprites[@tag].sprites[@index]

    _spriteCount: ->
      @sprites[@tag].sprites.length

    _isLastSprite:->
      @index is @_spriteCount() - 1

    _render: (context) ->
      context.drawImage @_sprite(), @width / -2, @height / -2

  Fabric.Sprite.async = true

