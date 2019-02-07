// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require filterrific/filterrific-jquery
//= require moment
//= require Chart
//= require_tree ./global

$(function() {
  if ($(".flash.error")) {
    $(".flash.error").slideDown('slow', 'swing', function() {});

    $("#close_flash").on("click", function() {
      console.log("click");
      $(this).parent().slideUp('slow', 'swing', function() {});
    });
  }
  if ($(".flash.success")) {
    $(".flash.success").slideDown('slow', 'swing', function() {});

    $("#close_flash").on("click", function() {
      console.log("click");
      $(this).parent().slideUp('slow', 'swing', function() {});
    });
  }
  $('.creditCardText').keyup(function() {
    var sort_code = $(this).val().split("-").join(""); // remove hyphens
    if (sort_code.length > 0) {
      sort_code = sort_code.match(new RegExp('.{1,2}', 'g')).join("-");
    }
    $(this).val(sort_code);
  });

});
