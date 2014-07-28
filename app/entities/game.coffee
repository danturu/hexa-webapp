define ["cs!application", "cs!environment", "cs!entities/cell", "backbone", "backbone.relational"], (Hexa, Environment, Cell, Backbone) ->
  class Model extends Backbone.RelationalModel
    urlRoot: "#{Environment.ENDPOINT}/api/v1/audio"

    relations: [
      {
        type           : Backbone.HasMany
        key            : "plots"
        relatedModel   : Cell.PlotModel
        collectionType : Cell.PlotCollection
      }

      {
        type           : Backbone.HasMany
        key            : "units"
        relatedModel   : Cell.UnitModel
        collectionType : Cell.UnitCollection
      }
    ]

    w: ->
      @get "w"

    h: ->
      @get "h"

    cells: ->
      @get "cells"

    units: ->
      @get "units"

  class Collection extends Backbone.Collection
    model: Model

  # EXPORTS

  Model      : Model
  Collection : Collection
