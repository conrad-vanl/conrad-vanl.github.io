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

$.fn.screenPreview = (method) ->
  # @ = jquery object
  # $(".screen").screenPreview()
  # We need to do a few things:
  #  0. go ahead and actively create the preview overlay
  #  0a. initiate a listener for the preview overlay
  #  0b. add previewer object to cache
  #  OR ...
  #    IF preview container has already been created, then just take that and continue
  #
  #  1. go ahead and actively create the preview container
  #     should initiate a new object for this preview container
  #  2. bind click event on this to open preview container object 

  class Previewer
    ###

      Put IMAGE width inside a data- attribute so that we can access it here
      Then, when opening, we can much better animate the needed width and what not?
      YEAH!

    ###
    isOpened = false

    constructor: (@parent) ->
      # create preview container 
      #div = $("<div class='screen-full'></div>")
      div = $('<div></div>').html(@parent.html())
      div.attr("class", @parent.attr("class"))
      container_div = $("<div class='screen-full'></div>").html(div)
      @object = container_div
      @addListeners()

    addListeners: () ->
      # windo resize
      $(window).on "resize", @position
      @position()
    
      # click function
      @parent.on "click", => @open()

    width: () ->
      img = new Image()
      img.src = @object.find("img").attr("src")
      
      if img.width > $(window).width()
        return $(window).width()
      else
        return img.width

    position: () ->
      if @isOpened
        @object.css("top", $(window).scrollTop())
        @object.css("left", ($(window).width() - @width())/2)
        @object.css("width", @width())
      else
        # take on position of parent
        @object.css("width", @parent.width())
        @object.css("top", @parent.offset().top)
        @object.css("left", @parent.offset().left)

    open: () ->
      # animate opening:
      #  start at position relative to the parent object
      #  end at a position absolute to the window
      if !$.contains($("body"), @object)
        $("body").append(@object)
        @object.position()
      $("body").append($("<div class='screen-full-overlay'></div>"))

      @isOpened = true

      @object.addClass("active")
      $(".screen-full-overlay").addClass("active")
      @position()
      @object.one "click", => @close()

    close: () ->
      # animate closing:
      #  start at position absolute to the window
      #  end at position relative to the parent object 
      @isOpened = false
      @position()
      @object.removeClass("active")
      $(".screen-full-overlay").removeClass("active")

      # wait for transition to be done, then remove from DOM:
      #transition = @whichTransitionEvent()
      #@object.one(transition, (=> console.log("after close"); @object.addClass("after-close")), false)
      @object.bind("webkitTransitionEnd oTransitionEnd otransitionend transitionend msTransitionEnd", (=>
        @object.remove()
        $(".screen-full-overlay").remove()
      ))


  @.each ->
    if !$(@).data("screenPreview")
      @_data = {}
      @_data.previewer = new Previewer($(@))

      $(@).data("screenPreview", @_data)

  return @


$(".screen").screenPreview()