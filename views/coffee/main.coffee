$(document).ready ->
  $.fn.smartbg = (url, time, cb) ->
    t = this
    # create an img so the browser will download the image: 
    $("<img />").attr("src", url).load ->
      $(t).css "backgroundImage", "url(#{url})"
      $(t).fadeIn time, ->
        cb t if typeof cb is "function"
    this
  animals = [
    "aphid",
    "bumblebee",
    "cardinal",
    "chameleon",
    "cicada",
    "cobra",
    "cricket",
    "frog",
    "gator",
    "giraffe",
    "grizzly",
    "hare",
    "hawk",
    "hippo",
    "hornet",
    "jaguar",
    "ladybug",
    "lion",
    "macaw",
    "monkey",
    "newt",
    "peacock",
    "perch",
    "python",
    "rattlesnake",
    "raven",
    "rhino",
    "scorpion",
    "swan",
    "termite",
    "tick",
    "tiger",
    "turtle",
    "viper",
    "woodpecker",
    "zebra"
  ]
  # Background images are just the prettiest animals
  bImages = [
    "cardinal.jpg",
    "chameleon.jpg",
    "cobra.jpg",
    "frog.jpg",
    "gator.jpg",
    "giraffe.jpg",
    "grizzly.jpg",
    "hare.jpg",
    "hawk.jpg",
    "hippo.jpg",
    "jaguar.jpg",
    "ladybug.jpg",
    "lion.jpg",
    "macaw.jpg",
    "monkey.jpg",
    "newt.jpg",
    "peacock.jpg",
    "perch.jpg",
    "python.jpg",
    "rattlesnake.jpg",
    "rhino.jpg",
    "swan.jpg",
    "tiger.jpg",
    "turtle.jpg",
    "woodpecker.jpg",
    "zebra.jpg"
  ]
  backs = $(".back")
  for b, i in bImages
    $(backs[i]).smartbg "/images/backgrounds/#{bImages[i]}", 50

  num = Math.floor(Math.random()*bImages.length)
  $(backs[num]).addClass "shown"
  setInterval ->
    $(".back.shown").removeClass "shown"
    num = Math.floor(Math.random()*bImages.length)
    $(backs[num]).addClass "shown"
  , 10000

  $(window).scroll ->
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

  nodes = {}
  $.get("http://bumblebee.zoo.cs.yale.edu:6789/zoo", (data) ->
    if data
      lines = data.split "\n"
      for line in lines
        entries = line.split "|"
        if entries.length is 8
          node = entries[6].replace /^\s+|\s+$/g, ""
          if node in animals 
            ip = entries[5]
            if ip and /\./.test ip
              nodes[node] = true
      for key,val of nodes
        $("td[name=#{key}]").addClass "used"
        
    else
      alert "Zoo availability data unavailable :("
  )
