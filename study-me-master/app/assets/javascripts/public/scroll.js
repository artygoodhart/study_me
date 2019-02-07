function setMenuOpacity() {
  var opacity, minOpacity, height, scroll, colour;

  minOpacity = 0.9;

  height = $(".banner").height();
  scroll = $(window).scrollTop();

  // Set the opacity of the menubar to be proportional to how far the user has
  // scrolled down on the top banner, handling potential divide by zero errors
  if (scroll == 0) {
    opacity = 0;
  } else {
    opacity = scroll / (height - 48);
  }

  // Set maximum opacity to 1
  if (opacity > 1) {
    opacity = 1;
  }

  if ($(".menu i").hasClass("active") && opacity < minOpacity) {
    colour = "rgba(249, 174, 0, " + minOpacity + ")";
  } else {
    colour = "rgba(249, 174, 0, " + opacity + ")";
  }

  $(".menu").css("background-color", colour);
  $("ul.dropdown li").css("background-color", colour);
}


function isInViewport(parent, grid) {
  var aboveBottom = false, belowTop = false;

  aboveBottom = parent.offset().top - $(window).scrollTop() < $(window).outerHeight();
  belowTop = grid.offset().top + grid.outerHeight() - $(window).scrollTop() > 0;

  return aboveBottom && belowTop;
}

function updateGrids() {
  if (isInViewport($("#live-studies"), $(".studies.grid"))) {
    if (!$(".studies.grid").is(":visible")) {
      $(".studies.grid").slideDown();
    }
  } else {
    if ($(".studies.grid").is(":visible")) {
      $(".studies.grid").slideUp();
    }
  }
}

$(function() {
  console.log("ITS WORKIMG");
  setMenuOpacity();
  // setWelcomeMenuOpacity();

  $(window).on("scroll", function() {
    setMenuOpacity();
    // setWelcomeMenuOpacity();
    //updateGrids();
  });

  $("#scroll-arrow").on("click", function() {
    // Take into account the menubar with a height of 48px
    var minus;

    if ($(".menu").is(":visible")) {
      minus = 88;
    } else {
      minus = 0;
    }

    // Scroll to live studies section
    $("html, body").animate({
      scrollTop: $("#live-studies").offset().top - minus
    }, 1000);
  });

  $(".menu i").on('click', function(el, event) {
    if ($('.menu .dropdown li').is(':animated'))
    {
        return false;
    }

    if ($(this).hasClass("active")) {
      $(this).removeClass("active");
      $(".menu").removeClass("active");

      $(".menu .dropdown").css("border-color", "rgba(255, 255, 255, 0)");
      $(".menu .dropdown li").css("border-color", "rgba(255, 255, 255, 0)");

      $(".menu .dropdown li").slideUp(1000, function() {
        $(".menu .dropdown").hide();
        $(".menu").css("-webkit-transition", "none");
        $(".menu").css("-moz-transition", "none");
        $(".menu").css("transition", "none");
      });

      setMenuOpacity();
      // setWelcomeMenuOpacity();
    } else {
      $(this).addClass("active");
      $(".menu").css("-webkit-transition", "background 2s");
      $(".menu").css("-moz-transition", "background 2s");
      $(".menu").css("transition", "background 2s");
      setMenuOpacity();
      // setWelcomeMenuOpacity();

      $(".menu .dropdown").show();
      $(".menu .dropdown li").slideDown(1000);
      $(".menu .dropdown").css("border-color", "#FAE8C1");
      $(".menu .dropdown li").css("border-color", "#FAE8C1");
    }
  });
});
