# Click handlers for interacting with posts

$(document).ready( ->

  # Attach click handler to AJAX upvote a post
  $('.post-upvote-arrow').on 'click', ->
    $.ajax
      type: 'PUT'
      url: "/post/#{$(this).data('id')}/upvote"
      success: ->
        Turbolinks.enableTransitionCache(true)
        Turbolinks.visit(location.toString())
        Turbolinks.enableTransitionCache(false)

  # Attach click handler to AJAX remove an upvote on a post
  $('.post-upvote-arrow-undo').on 'click', ->
    $.ajax
      type: 'DELETE'
      url: "/post/#{$(this).data('id')}/upvote"
      success: ->
        Turbolinks.enableTransitionCache(true)
        Turbolinks.visit(location.toString())
        Turbolinks.enableTransitionCache(false)

  $('.reply-button').on 'click', ->
    console.log $(this).data('id')
    $("##{$(this).data('id')}").toggleClass 'hide'
)