$('.work-articles').carousel
  interval: false

# Fix Work-articles sizing
# .work-media-well set to 90% window height
# .work-article-container margin-top set to -(50% window height)
fixWorkSizing = () ->
  windowHeight = $(window).height()

  # iterate through each instance:
  $(".work-article").each (i, e) ->
    $e = $(e);
    $e.find(".work-media-well").css("height", (windowHeight * .85)+"px")

    upToMiddle = ( $e.find(".work-media-well").height() * .5 + 80 );
    upToMiddle = $e.find(".work-media-well").height() if upToMiddle >= $e.find(".work-media-well").height()
    $e.find(".work-article-container").css("margin-top", "-" + upToMiddle + "px") if !$e.hasClass("smalls")

  # AFfix controls:
  $('.work-articles .carousel-controls').first().affix( offset: top: $(".work-media-well").offset().top - windowHeight/2)

fixWorkSizing()
$(".work-articles").on("slid", fixWorkSizing)