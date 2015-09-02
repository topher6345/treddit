# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

console.log 'loaded'
$(document).ready( ->
  $('.post-upvote-arrow').on 'click', ->
    console.log $(this).data('id')
    $.ajax
      type: 'PUT'
      url: "/post/#{$(this).data('id')}/upvote"
      success: ->
        Turbolinks.enableTransitionCache(true)
        Turbolinks.visit(location.toString())
        Turbolinks.enableTransitionCache(false)

  $('.reply-button').on 'click', ->
    console.log $(this).data('id')
    $("##{$(this).data('id')}").toggleClass 'hide'
)