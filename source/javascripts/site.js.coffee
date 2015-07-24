#= require jquery/jquery
#= require jquery.smooth-scroll/jquery.smooth-scroll.js
#= require letteringjs/jquery.lettering.js
#= require vague.js/Vague.js
# require magnific-popup/dist/jquery.magnific-popup.js
#= require greensock/src/uncompressed/TweenMax.js
#= require scrollmagic/scrollmagic/uncompressed/ScrollMagic.js
#= require scrollmagic/scrollmagic/uncompressed/plugins/animation.gsap.js
#= require prefixfree.min.js
#= require pace
#= require bootstrap

#= require _modules/lettering
#= require _modules/mockup-preview

$("a").not(".work-article a").not("a[href=#squaresend]").not(".mockup-preview-controls a").smoothScroll()

$(".work-article-target").each (i, e) ->
  e = $(e)
  vague = e.find(".img-container img").Vague intensity: 5
  e.on "mouseover", -> vague.blur()
  e.on "mouseout", -> vague.unblur()

#$(".image-expand").magnificPopup(type: 'image')

# preload main image
# image = "/images/background.jpg"
# window.i = i = new Image()
# i.onload = ->
#   $(".preloader").fadeOut()
# i.src = image

Pace.on "hide", ->
  $(".preloader").fadeOut()

controller = new ScrollMagic.Controller()

tween = TweenMax.to(".background-container", 1, { y: "15%" })

scene = new ScrollMagic.Scene( triggerElement: 0, duration: $(".background-container").height() )
  .setTween(tween)
  .addTo(controller)