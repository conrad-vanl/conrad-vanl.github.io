#= require jquery/jquery
#= require jquery.smooth-scroll/jquery.smooth-scroll.js
#= require letteringjs/jquery.lettering.js
#= require vague.js/Vague.js
# require magnific-popup/dist/jquery.magnific-popup.js

#= require bootstrap

#= require _modules/lettering
#= require _modules/mockup-preview

$("a").not(".work-article a").not(".mockup-preview-controls a").smoothScroll()

$(".work-article a").each (i, e) ->
  e = $(e)
  vague = e.find(".img-container img").Vague intensity: 5
  e.on "mouseover", -> vague.blur()
  e.on "mouseout", -> vague.unblur()

#$(".image-expand").magnificPopup(type: 'image')
