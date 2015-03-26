animationEndPrefixes = "animationend webkitAnimationEnd oAnimationEnd MSAnimationEnd"

$.fn.mockupPreview = ( action, options ) ->
  defaultSettings = 
    showOn: "click"
    hideOn: "click"
    inner: ".mockup-preview"
    backdropClass: "mockup-preview-backdrop"
    controls: $(".mockup-preview-controls")
    showCSS:
      width: -> $(window).width() #$(".work-articles").width()
      left:  -> $(this).offset().left * -1
    hideCSS:
      width: "100%"
      left: 0

  dataKey = "mockupPreview.settings"
  animationEndPrefixes = animationEndPrefixes

  actions =
    show: (element) ->
      $e = (element)
      settings = $.extend( defaultSettings, options )

      $(".mockup-preview-trigger.active").mockupPreview("hide", settings)

      scrollPos = $(window).scrollTop()
      $e.one "mockup-preview-deactivate", ->
        $.smoothScroll(scrollPos)
      
      $inner = $e.find(settings.inner)
      return if !$inner or $inner.hasClass("in")

      $.smoothScroll($e.offset().top - 50)
      $e.addClass("active")
      $inner.removeClass("out").addClass("in").css(settings.showCSS) #.one animationEndPrefixes, -> #$inner.removeClass("out")
      $e.trigger("mockup-preview-activate")

      #$inner.one settings.hideOn, (e) -> 
      #  e.preventDefault()
      #  e.stopPropagation()
      #  $e.mockupPreview("hide", settings)

    hide: (element) ->      
      $e = $(element)
      settings = $.extend( defaultSettings, options )
      
      $inner = $e.find(settings.inner)
      return if !$inner or !$inner.hasClass("in")
      
      $e.removeClass("active")
      $inner.addClass("out").css(settings.hideCSS).one animationEndPrefixes, -> $inner.removeClass("in")
      $e.trigger("mockup-preview-deactivate")


    _buildNav: (elements) ->
      return if !elements
      settings = $.extend( defaultSettings, options )
      controls = $(settings.controls)
      return if !controls

      # build link items
      list = controls.find("[data-mockup-preview-items]")
      if list
        elementName = list.attr("data-mockup-preview-items") or "li"
        elements.each (i) ->
          $("<#{elementName}><a href=\"##{$(this).attr("id")}\"> </a></#{elementName}>").appendTo(list).on "click", (e) ->
            #e.preventDefault()
            e.stopPropagation()
            a = $(this).find("a")
            item = $(a.attr("href"))
            return if !item or item.hasClass("active")
            item.mockupPreview("show", settings)

      # observe items for class change on "active"
      $(this).on "mockup-preview-activate", (e) =>
        $e = $(e.target)
        return if !$e

        # slide down controls if not already
        controls.removeClass("out").addClass("in") if controls and !controls.is(":visible")

        # setup link
        list.find(".active").removeClass("active")
        listItem = list.find("[href=#"+$e.attr("id")+"]")
        listItem.addClass("active")
        # insert title
        controls.find("[data-mockup-preview-title]").html($e.attr("data-mockup-preview-title"))
        # hook-up link
        controls.find("[data-mockup-preview-link]").attr("href", $e.attr("href"))
        if !$e.attr("href") or $e.attr("href") is "#"
          controls.find("[data-mockup-preview-link]").hide()
        else
          controls.find("[data-mockup-preview-link]").show()

        # hook-up next link
        pos = elements.index($e) || elements.index(e.target)
        if pos >= 0
          pos = pos + 1
          pos = 0 if pos >= elements.length
          nextPreview = $(elements[pos])
          if nextPreview
            controls.find("[data-mockup-preview-next]").attr("href", "#"+nextPreview.attr("id"))

      $(this).on "mockup-preview-deactivate", (e) =>
        # only slide up if nothing is active
        setTimeout(->
          if !elements.hasClass("active")
            controls.addClass("out").one animationEndPrefixes, -> controls.removeClass("in")
        , 100)

      # setup next link observer
      controls.find("[data-mockup-preview-next]").on "click", (e) ->
        e.preventDefault()
        e.stopPropagation()
        item = $($(this).attr("href"))
        return if !item or item.hasClass("active")
        item.mockupPreview("show", settings)

      # setup close link observer
      controls.find("[data-mockup-preview-close]").on "click", (e) ->
        e.preventDefault()
        e.stopPropagation()
        item = $(controls.find(".active").attr("href"))
        return if !item
        item.mockupPreview("hide", settings)

      controls.appendTo $("body")

  if !options and typeof action isnt "string"
    options = action

  if typeof action is "string"
    func = actions[action]
    func(this) if func

  else
    settings = $.extend( defaultSettings, options )

    if this.length > 1
      this.mockupPreview("_buildNav", settings)

    return this.each ->
      $this = $(this)
      $preview = $this.find(settings.inner)
      return if !$preview

      $this.addClass("mockup-preview-trigger")

      #jQuery.data( $this, dataKey, settings )
      this.settings = settings

      $this.on settings.showOn, (e) ->
        #e.preventDefault() 
        e.stopPropagation()
        $this.mockupPreview("show", settings)



$(".work-article").mockupPreview()

# real simple dirty throttle
callMethod = (target, method, args) ->
  method = target[method] if typeof method is "string"
  method.apply target, args

debounce = (target, method, wait, immediate) ->
  timeout = undefined
  if typeof method is "number"
    immediate = wait
    wait = method
    method = target
    target = this
  ->
    later = undefined
    args = arguments
    later = ->
      timeout = null
      callMethod target, method, args  unless immediate

    callMethod target, method, args  if immediate and not timeout
    clearTimeout timeout
    timeout = setTimeout(later, wait)

throttle = (target, method, wait) ->
  timeout = undefined
  throttling = undefined
  more = undefined
  result = undefined
  whenDone = undefined
  if typeof method is "number"
    wait = method
    method = target
    target = null
  whenDone = debounce(->
    more = throttling = false
  , wait)
  ->
    later = undefined
    args = arguments
    later = ->
      timeout = null
      callMethod target, method, args  if more
      whenDone()

    timeout = setTimeout(later, wait)  unless timeout
    if throttling
      more = true
    else
      result = callMethod(target, method, args)
    whenDone()
    throttling = true
    result

# style fix - fade out nav when scrolling to high
$(window).on "scroll", throttle(->
  active = $(".work-articles a.active")
  return if active.length is 0
  
  top = $(".work-container").offset().top
  controls = $(".mockup-preview-controls")
  if ($(window).scrollTop() + $(window).height()/2) < top
    if !controls.hasClass("out")
      controls.addClass("out").one animationEndPrefixes, -> controls.removeClass("in")
  else
    if !controls.hasClass("in")
      controls.removeClass("out").addClass("in")
, 200)

# style fix - adjust iframe height automatically 16:9 ratio
$(".mockup-preview-container").has("iframe").parent(".work-article").on "mockup-preview-activate", ->
  iframe = $(this).find("iframe")
  iframe.height $(this).parents(".container").first().width() * (9/16)

$(".mockup-preview-container").has("iframe").parent(".work-article").on "mockup-preview-deactivate", ->
  iframe = $(this).find("iframe")
  iframe.height $(this).height()