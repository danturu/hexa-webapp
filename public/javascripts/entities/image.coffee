define ["cs!app", "backbone", "backbone.relational"], (Hexa, Backbone) ->
  class Model extends Backbone.RelationalModel
    tag: ->
      @get "tag"

    url: ->
      @get "url"

    spriteW: ->
      @get "sprite_w"

    spriteH: ->
      @get "sprite_h"

  class Collection extends Backbone.Collection
    model: Model

  Hexa.addInitializer ->
    new Collection Hexa.bootstrapData.objects.plots

  # EXPORTS

  Model      : Model
  Collection : Collection
