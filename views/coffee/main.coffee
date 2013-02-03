$(document).ready ->
  $.fn.smartbg = (url, time, cb) ->
    t = this
    # create an img so the browser will download the image: 
    $("<img />").attr("src", url).load ->
      $(t).css "backgroundImage", "url(#{url})"
      $(t).fadeIn time, ->
        cb t if typeof cb is "function"
    this
  # Setup
  bImages = [
    "lion.jpg",
    "bumblebee.jpg"
  ]
  # Load large background images separately
  $(".back").smartbg("/images/backgrounds/lion.jpg", 200)

  $(window).scroll ->
    console.log $("body").scrollTop(), $(window).height()
    if $("body").scrollTop() < $(window).height() - 40 
      $("#zoo-nav").slideUp("fast")
    else
      $("#zoo-nav").slideDown("fast")

  $(".js-nav").click ->
    tar = $(this).attr "target"
    dest = $(".panel[name=#{tar}]").offset().top
    $("body,html,document").animate
        scrollTop: dest-40
      , 300
