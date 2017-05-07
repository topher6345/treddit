# Client-side which assumes you've already requested
# the right to send web notifications.

if "/stream/index" == window.location.pathname
  App.cable.subscriptions.create channel: "WebNotificationsChannel",
    connected: ->
      # console.log("connected to WebNotificationsChannel")
    received: (html) ->
      $('#live-stream').prepend(html)
