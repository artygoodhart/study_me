//= require jquery
//= require jquery_ujs
//= require ./devise

function setWelcomeMenuOpacity() {
  var opacity, minOpacity, height, scroll, colour;

  minOpacity = 0.9;

  height = $(".welcome-container").height();
  scroll = $(window).scrollTop();

  // Set the opacity of the menubar to be proportional to how far the user has
  // scrolled down on the top banner, handling potential divide by zero errors
  if (scroll == 0) {
    opacity = 0;
  } else {
    opacity = scroll / (height - 1300);
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

  if ($(".flash.error")) {
    $(".flash.error").slideDown('slow', 'swing', function() {});

    $("#close_flash").on("click", function() {
      console.log("click");
      $(this).parent().slideUp('slow', 'swing', function() {});
    });
  }
}

$(function() {
  setWelcomeMenuOpacity();

  $(window).on("scroll", function() {
    setWelcomeMenuOpacity();
    //updateGrids();
  });
});
