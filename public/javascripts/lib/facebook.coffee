define ["facebook"], ->
  isLoggedIn = (callback) ->
    FB.getLoginStatus (response) -> callback(response and response.status is "connected")

  login = (callback) ->
    FB.login (response) -> callback(response and !!response.authResponse)

  request = ->
    FB.api.apply @, Array::slice.call(arguments, 0).concat (response) -> deferred.resolve response

    deferred = $.Deferred()
    deferred.promise()

  challenge = (message, params, callback) ->
    FB.ui method: "apprequests", message: message, to: params.to, data: params.data, (response) ->
      callback(response and response.request)

  # EXPORTS

  isLoggedIn : isLoggedIn
  login      : login
  request    : request
  challenge  : challenge
