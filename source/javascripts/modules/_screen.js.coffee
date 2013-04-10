###
handleClick = (e) ->
  e.stopPropagation() 

  $e = $(e.target).parents(".screen").first()

  # case 1: close element:

  if($e.hasClass("screen-full"))
    $("body").find(".screen-full").remove()
    $("body").find(".screen-full-overlay").remove()


  else 
  # case 2: open element:

    # create copy of element:
    $d = $('<div></div>').html($e.html())
    $d.attr("class", $e.attr("class"))
    $d.addClass("screen-full")
    $d.addClass("before-zoom")

    $("body").find(".screen-full").remove()
    $("body").find(".screen-full-overlay").remove()

    $("body").append($("<div class='screen-full-overlay'></div>"))
    $("body").append($d)
    $d.css("margin-left", 0)
    $d.css("top", window.pageYOffset + 10)

    $d.on "click", handleClick

    sizeWindows()

  return false

$(".screen").on "click", handleClick


sizeWindows = () ->
  $(".screen-full").each (i, e) ->
    console.log "screen-ful", e, $(e)
    $e = $(e)
    #calcWidth, calcMargin
    calcWidth = $(window).width() * 0.85
    $e.css("max-width",calcWidth)

    calcMargin = ($(window).width() - $e.width()) / 2
    $e.css("margin-left",calcMargin)

$(window).on "resize",  sizeWindows
###

$.fn.screenPreview = ->
  # @ = jquery object
  # $(".screen").screenPreview()
  # We need to do a few things:
  #  0. go ahead and actively create the preview overlay
  #  1. go ahead and actively create the preview container
  #     should initiate a new object for this preview container
  #  2. bind click event on this to open preview container object  

  class Previewer
    constructor: (@parent) ->
      # create preview container 
      # create the container only if it hasn't been already?

    open: () ->
      # animate opening:
      #  start at position relative to the parent object
      #  end at a position absolute to the window

    close: () ->
      # animate closing:
      #  start at position absolute to the window
      #  end at position relative to the parent object 

