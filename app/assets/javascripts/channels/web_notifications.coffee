# Client-side which assumes you've already requested
# the right to send web notifications.
App.cable.subscriptions.create channel: "WebNotificationsChannel",
  connected: ->
    console.log("connected to WebNotificationsChannel")
  received: (html) ->
    $('ul#live-stream').prepend(html)
