###*
# Main JS file for Casper behaviours
###

### globals jQuery, document ###

(($) ->
  'use strict'
  $document = $(document)
  $document.ready ->
    $postContent = $('.post-content')
    $postContent.fitVids()
    $('.scroll-down').arcticScroll()
    $('.menu-button, .nav-cover, .nav-close').on 'click', (e) ->
      e.preventDefault()
      $('body').toggleClass 'nav-opened nav-closed'
      return
    return
  # Arctic Scroll by Paul Adam Davis
  # https://github.com/PaulAdamDavis/Arctic-Scroll

  $.fn.arcticScroll = (options) ->
    defaults =
      elem: $(this)
      speed: 500
    allOptions = $.extend(defaults, options)
    allOptions.elem.click (event) ->
      event.preventDefault()
      $this = $(this)
      $htmlBody = $('html, body')
      offset = if $this.attr('data-offset') then $this.attr('data-offset') else false
      position = if $this.attr('data-position') then $this.attr('data-position') else false
      toMove = undefined
      if offset
        toMove = parseInt(offset)
        $htmlBody.stop(true, false).animate { scrollTop: $(@hash).offset().top + toMove }, allOptions.speed
      else if position
        toMove = parseInt(position)
        $htmlBody.stop(true, false).animate { scrollTop: toMove }, allOptions.speed
      else
        $htmlBody.stop(true, false).animate { scrollTop: $(@hash).offset().top }, allOptions.speed
      return
    return

  return
) jQuery
