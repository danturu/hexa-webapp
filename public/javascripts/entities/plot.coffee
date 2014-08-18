define ["cs!app", "cs!entities/image", "backbone", "backbone.relational"], (Hexa, Image, Backbone) ->
  class Model extends Backbone.RelationalModel
    @tag: "plot"

    relations: [
      {
        type           : Backbone.HasMany
        key            : "images"
        relatedModel   : Image.Model
        collectionType : Image.Collection
      }
    ]

  class Collection extends Backbone.Collection
    model: Model

  Hexa.addInitializer ->
    new Collection Hexa.bootstrapData.objects.plots

  # EXPORTS

  Model      : Model
  Collection : Collection
