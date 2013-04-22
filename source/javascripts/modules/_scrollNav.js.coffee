navList = [
  [0, 0]
  [".welcome-container", 1]
  ["#about-wrapper", .5]
  ["#work-wrapper", 0]
]
window.navList = navList

scrollPos = (e, p = 0) ->
  # returns the scroll position of element, position pair
  if typeof e is "number"
    top = 0
    height = 0
  else
    $e = $(e)
    top = $e.offset().top || 0
    height = $e.height() || 0

  return top - (($(window).height() - height) * p)

nextPos = ->
  # returns tuple of next position
  scroll = $(window).scrollTop()
  for a in navList
    if scrollPos(a...) > (scroll)
      return scrollPos(a...)
  return scrollPos(navList[0])

prevPos = ->
  # returns tuple of prev position
  scroll = $(window).scrollTop()
  for a in navList.slice(0).reverse()
    if scrollPos(a...) < (scroll - 1)
      return scrollPos(a...)
  return scrollPos([navList.length - 1])


jwerty.key '↓/→', (e) ->
  e.preventDefault()
  TweenLite.to(window, 1, {scrollTo:{y:nextPos()}})

jwerty.key '↑/←', (e) ->
  e.preventDefault()
  #TweenLite.to(window, 1, {scrollTo:})
  TweenLite.to(window, 1, {scrollTo:{y:prevPos()}})