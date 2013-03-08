$(document).ready ->
  ZOOMACHINE = "python"
  animals = [
    "aphid",
    "bumblebee",
    "cardinal",
    "chameleon",
    "cicada",
    "cobra",
    "cricket",
    "dolphin",
    "frog",
    "gator",
    "giraffe",
    "grizzly",
    "hare",
    "hawk",
    "hippo",
    "hornet",
    "jaguar",
    "kangaroo",
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
  $.fn.smartbg = (url, time, cb) ->
    t = this
    # create an img so the browser will download the image:
    $("<img />").attr("src", url).load ->
      $(t).css "backgroundImage", "url(#{url})"
      $(t).fadeIn time, ->
        cb t if typeof cb is "function"
    this

  getAvailability = ->
    console.log "fetching availability..."
    $.get("http://#{ZOOMACHINE}.zoo.cs.yale.edu:6789/zoo", (data) ->
      if data
        nodes = {}
        lines = data.split "\n"
        for line in lines
          entries = line.split "|"
          if entries.length is 8
            # entries[6] is the node name
            node = entries[6].replace /^\s+|\s+$/g, ""  # Trim whitespace
            if node in animals
              nodes[node] ||= {}
              n = nodes[node]
              n.num ||= 0                               # Just for curiosity
              n.num++                                   # keep track of number
              ip = entries[5]
              # Considered in use if at least one ip field reads 'console'
              if /console/.test ip
                n.used = true
                theTime = entries[2]
                if /\w\w\w \d+:\d+/.test theTime        # e.g. Thu 21:45
                  day = moment(theTime, "ddd HH:mm")    # Parse the date
                  day.year(moment().year())             # Manually set year
                  day.month(moment().month())           # and month
                  weekDay = theTime.split(" ")[1]
                  day.date(moment().date())             # Assume it's today
                  if weekDay isnt moment().format("ddd")# If the days don't match
                    day.sub 'd', 1                      # assume it's yesterdayyesterday

                  n.time = "for about #{day.fromNow(true)}."
                else if /\w\w\w \d\d/.test theTime      # e.g. Jan 23
                  n.time = "for a minuuuuuute"
                else
                  n.time ||= "for an unknown amount of time"

        for animal in animals
          node = nodes[animal]
          if node and node.used
            $("td[name=#{animal}]")
              .addClass("used")
              .find(".overlay-text")              # Set the overlay text
              .html "<b>#{animal}</b> has been in use #{node.time}"
          else
            $("td[name=#{animal}]")
              .addClass("free")
              .find(".overlay-text")
              .html "<b>#{animal}</b> is available!"
      else
        alert "Zoo availability data unavailable :( Try refreshing the page."
        clearInterval(availabilityInterval) if availabilityInterval
    ).error ->
      alert "Zoo availability data unavailable :( Try refreshing the page."
      clearInterval(availabilityInterval) if availabilityInterval

  availabilityInterval = setInterval getAvailability, 60*1000
  getAvailability()


  # Background images are just the prettiest animals
  bImages = [
    "cardinal.jpg",
    "chameleon.jpg",
    "cobra.jpg",
    "dolphin.jpg",
    "frog.jpg",
    "gator.jpg",
    "giraffe.jpg",
    "grizzly.jpg",
    "hare.jpg",
    "hawk.jpg",
    "hippo.jpg",
    "jaguar.jpg",
    "kangaroo.jpg",
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

  zooBarBottom = $(".zoo-main-bar").offset().top + $(".zoo-main-bar").height()
  $(window).scroll ->
    if $("body").scrollTop() < zooBarBottom
      $("#zoo-nav").slideUp("fast")
    else
      $("#zoo-nav").slideDown("fast")

  $(".js-nav").click ->
    tar = $(this).attr "target"
    dest = $(".panel[name=#{tar}]").offset().top
    $("body,html,document").animate
        scrollTop: dest-40
      , 300

  $(".overlay-text").html "Data for this node unknown"

