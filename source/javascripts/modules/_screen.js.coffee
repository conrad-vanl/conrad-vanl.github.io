handleClick = (e) ->
  e.stopPropagation() 

  $e = $(e.target).parents(".screen").first()

  # case 1: close element:
  console.log $e, $e.parent()

  if($e.hasClass("screen-full"))
    $("body").find(".screen-full").remove()
    $("body").find(".screen-full-overlay").remove()


  else 
  # case 2: open element:

    # create copy of element:
    $d = $('<div></div>').html($e.html())
    $d.attr("class", $e.attr("class"))
    $d.addClass("screen-full")

    $("body").find(".screen-full").remove()
    $("body").find(".screen-full-overlay").remove()

    $("body").append($("<div class='screen-full-overlay'></div>"))
    $("body").append($d)
    $d.css("margin-left", -$d.width()/2)
    $d.css("top", window.pageYOffset)

    $d.on "click", handleClick

  return false

$(".screen").on "click", handleClick