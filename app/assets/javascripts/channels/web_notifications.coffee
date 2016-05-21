# Client-side which assumes you've already requested
# the right to send web notifications.
console.log 'loading subscribe'
App.cable.subscriptions.create channel: "WebNotificationsChannel",
  received: (data) ->
    console.log "fdsafs"
    new Notification data["title"], body: data["body"]