define ["cs!app", "cs!entities/image", "backbone", "backbone.relational"], (Hexa, Image, Backbone) ->
  class Model extends Backbone.RelationalModel
    @tag: "unit"

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
    new Collection Hexa.bootstrapData.objects.units

  # EXPORTS

  Model      : Model
  Collection : Collection
