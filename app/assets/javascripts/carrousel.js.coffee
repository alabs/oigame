$(document).ready ->
  slideContentChange = (args) ->

    # indicator
    $(args.sliderObject).parent().find(".iosSliderButtons .button").removeClass "selected"
    $(args.sliderObject).parent().find(".iosSliderButtons .button:eq(" + (args.currentSlideNumber - 1) + ")").addClass "selected"
  slideContentComplete = (args) ->
    return false  unless args.slideChanged

    # animation
    $(args.sliderObject).find(".text1, .text2").attr "style", ""
    $(args.currentSlideObject).children(".text1").animate
      right: "100px"
      opacity: "1"
    , 400, "easeOutQuint"
    $(args.currentSlideObject).children(".text2").delay(200).animate
      right: "50px"
      opacity: "1"
    , 400, "easeOutQuint"
  slideContentLoaded = (args) ->

    # animation
    $(args.sliderObject).find(".text1, .text2").attr "style", ""
    $(args.currentSlideObject).children(".text1").animate
      right: "100px"
      opacity: "1"
    , 400, "easeOutQuint"
    $(args.currentSlideObject).children(".text2").delay(200).animate
      right: "50px"
      opacity: "1"
    , 400, "easeOutQuint"

    # indicator
    $(args.sliderObject).parent().find(".iosSliderButtons .button").removeClass "selected"
    $(args.sliderObject).parent().find(".iosSliderButtons .button:eq(" + (args.currentSlideNumber - 1) + ")").addClass "selected"
  $(".iosSlider").iosSlider
    scrollbar: true
    snapToChildren: true
    desktopClickDrag: true
    scrollbarLocation: "top"
    scrollbarMargin: "10px 10px 0 10px"
    scrollbarBorderRadius: "0"
    responsiveSlideWidth: true
    navSlideSelector: $(".iosSliderButtons .button")
    infiniteSlider: true
    startAtSlide: "2"
    onSlideChange: slideContentChange
    onSlideComplete: slideContentComplete
    onSliderLoaded: slideContentLoaded
    navNextSelector: $('.nextButton')
    navPrevSelector: $('.prevButton')
