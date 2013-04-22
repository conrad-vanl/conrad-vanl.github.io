initScrollAnimations = () ->
  controller = $.superscrollorama()
  #controller.addTween(".welcome-header", TweenMax.to($(".welcome-header"), .5, {css:{opacity:1}}))

  # Welcome Wrapper
  controller.pin($("#welcome-wrapper"), 850, {
    offset: 1
    onPin: -> 
      $("#welcome-wrapper").css("right",0)
      $("#welcome-wrapper").css("background-attachment", "fixed")
    onUnpin: -> 
      $("#welcome-wrapper").css("position","relative")
      $("#welcome-wrapper").css("background-attachment", "inherit")
    anim: new TimelineLite()
      .append([
        TweenMax.to($(".welcome-screens"), 1,
          {css:{opacity:1,visibility:"visible"}}, ease: Quad.easeInOut
        )
        TweenMax.from($(".welcome-screens > *:not(*:first-child)"), 1,
          {css:{bottom:-600,opacity:0}}, ease: Quad.easeInOut
        )
        TweenMax.from($(".welcome-screens > *:first-child"), 1,
          {css:{bottom:-400}}, ease: Quad.easeInOut
        )
        TweenMax.to($(".welcome-header"), 1,
          {css:{top:"50%"}}, ease: Quad.easeInOut
        )
      ])
  })

  # Callout Section
  controller.addTween("#callout-wrapper",
    new TimelineLite()
      .append([
        TweenMax.from($("#callout-wrapper .container"), 0.8,
          {css:{opacity:0}},
          ease: Quad.easeInOut
        ),
        TweenMax.fromTo($("#callout-wrapper"), 0.5,
          {css:{paddingTop:0,paddingBottom:17*2}},
          {css:{paddingBottom:17,paddingTop:17}},
          ease: Quad.easeInOut
        )
      ]),
    0,
    -200
  )

  # About Section
  controller.addTween("#about-wrapper",
    new TimelineLite()
      .append([
        TweenMax.to($("#about-wrapper .container > *"), 1, {css:{opacity:1, visibility:"visible"}}, ease: Quad.easeInOut)
        TweenMax.fromTo($("#about-wrapper .nav li"), 0.8, 
          {css:{marginTop:-20,marginBottom:90}},
          {css:{marginTop:10,marginBottom:60}}, 
          ease: Quad.easeInOut
        )
      ])
  )
  controller.addTween("#about-wrapper",
    TweenMax.fromTo($("#about-wrapper"), 1,
      {css:{paddingTop:0,paddingBottom:70}},
      {css:{paddingTop:60,paddingBottom:10}}
    ), $(window).height()
  )

  # Work Section
  controller.addTween(".work-header-container",
    TweenMax.from($(".work-header-container"), 1, 
      {css:{top:0}}, ease: Quad.easeInOut
    ), 0, -250
  )
  controller.addTween(".work-header-container",
    TweenMax.to($(".work-header-container > *"), 0.8,
      {css:{opacity:1,visibility:"visible"}}, ease: Quad.easeInOut
    ), 0, -250
  )

  controller.addTween(".work-articles",
    new TimelineLite()
      .append([
        TweenMax.to($(".work-articles .container > *"), 0.5,
          {css:{opacity:1,visibility:"visible"}},
          ease: Quad.easeInOut
        )
      ])
    , 0, 200
  )

(new TimelineLite({onComplete:initScrollAnimations}))
  .append([
    TweenMax.from( $('.welcome-header'), 1.5, {css:{marginTop:"-300px", zoom: 10}}, ease: Quad.easeInOut)
    TweenMax.to( $('.welcome-header'), 2, {delay: 1, css:{opacity:1, visibility: "visible"}}, ease: Quad.easeInOut)
  ]).play()
