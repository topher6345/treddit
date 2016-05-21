# Client-side which assumes you've already requested
# the right to send web notifications.
console.log 'Subscribing to Live Event'
App.cable.subscriptions.create channel: "WebNotificationsChannel",
  received: (html) ->
    $('ul#live-stream').prepend(html)
