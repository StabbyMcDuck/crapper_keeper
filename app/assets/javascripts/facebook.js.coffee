jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  FB.init(appId: '1805926139684724', cookie: true)

  $('#facebook_sign_in').click (e) ->
   e.preventDefault()
   FB.login (response) ->
     console.log('FB.login called')
     window.location = '/auth/facebook/callback' if response.authResponse

  $('#sign_out').click (e) ->
   FB.getLoginStatus (response) ->
     FB.logout() if response.authResponse
   true
