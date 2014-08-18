define ->
  class Cache
    constructor: ->
      @store = {}

    get: (key, fallback, callback) ->
      return @store[key] unless fallback and callback

      if key of @store
        callback @store[key]
      else
        fallback (value) => callback @put key, value

    put: (key, value) ->
      @store[key] = value

    has: (key) ->
      key of @store

  # EXPORTS

  new Cache()