# Click handlers for interacting with posts

$(document).ready( ->

  $.ajax
    type: 'GET'
    url: "/upvotes"
    success: (data) ->
      if data == undefined
        console.log('not logged in')
      else
        console.log(data)
        $('.post-upvote-arrow').each (index, elem) ->
          id = parseInt(elem.dataset.id)
          if data['votes'].includes(id)
            $(elem).addClass('post-upvote-arrow-undo')

  # To collapse a post
  # TODO: make this collapse the children
  $('.collapser').on 'click', ->
    $(this).parent().parent().toggleClass 'post-collapse'

  # Attaches click handler to AJAX upvote a post
  $('.post-upvote-arrow').on 'click', ->
    $.ajax
      type: 'POST'
      url: "/posts/#{$(this).data('id')}/upvotes"
      success: ->
        Turbolinks.enableTransitionCache(true)
        Turbolinks.visit(location.toString())
        Turbolinks.enableTransitionCache(false)

  # Attaches click handler to AJAX remove an upvote on a post
  $('.post-upvote-arrow-undo').on 'click', ->
    $.ajax
      type: 'DELETE'
      url: "/posts/#{$(this).data('id')}/upvotes"
      success: ->
        Turbolinks.enableTransitionCache(true)
        Turbolinks.visit(location.toString())
        Turbolinks.enableTransitionCache(false)

  # Attaches click handler to reply to post button
  $('.reply-button').on 'click', ->

    # Toggles reply textarea
    $("##{$(this).data('id')}").toggleClass 'hide'

  # Attaches click handler to edit post button
  $('.edit-button').on 'click', ->

    # Toggle visibility of edit post elements
    $(this).parent().siblings('article').children('textarea').toggleClass('hide')
    $(this).parent().siblings('article').children('.post-body').toggleClass('hide')
    $(this).parent().siblings('article').children('button').toggleClass('hide')

    # Attaches click handler to save post update button
    $('.update-post').on 'click', ->

      # Grabs updated text from textarea
      textarea = $(this).parent('article').children('textarea').val()
      $.ajax({
        type: "PUT",
        url: "/posts/#{$(this).data('id')}",
        data: { post: { body: textarea } },
        success: ->
          Turbolinks.enableTransitionCache(true)
          Turbolinks.visit(location.toString())
          Turbolinks.enableTransitionCache(false)
    })
)