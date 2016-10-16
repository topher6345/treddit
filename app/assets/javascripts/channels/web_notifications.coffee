# Client-side which assumes you've already requested
# the right to send web notifications.
App.cable.subscriptions.create channel: "WebNotificationsChannel",
  connected: ->
    console.log("connected to WebNotificationsChannel")
  received: (html) ->
    console.log("received from WebNotificationsChannel"+html)
    $('#live-stream').prepend(html)
