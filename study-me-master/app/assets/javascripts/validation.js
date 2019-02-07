$(function() {
  $("#create-password").on("input", function() {
    var pass = $(this).val();

    if (/^[a-z0-9!@#\$%\^\&*\)\(+=._-]+$/.test(pass) || pass == "") {
      $("#capital-icon").removeClass("valid");
    } else {
      $("#capital-icon").addClass("valid");
    }

    if (/^[A-Z0-9!@#\$%\^\&*\)\(+=._-]+$/.test(pass) || pass == "") {
      $("#lower-icon").removeClass("valid");
    } else {
      $("#lower-icon").addClass("valid");
    }

    if (/^[a-zA-Z!@#\$%\^\&*\)\(+=._-]+$/.test(pass) || pass == "") {
      $("#number-icon").removeClass("valid");
    } else {
      $("#number-icon").addClass("valid");
    }

    if (/^[a-zA-Z0-9]*$/.test(pass) || pass == "") {
      $("#symbol-icon").removeClass("valid");
    } else {
      $("#symbol-icon").addClass("valid");
    }
  });

  $("#edit_researcher").on("submit", function(event) {
    if (!$("#capital-icon").hasClass("valid") || !$("#number-icon").hasClass("valid") || !$("#symbol-icon").hasClass("valid")) {
      event.preventDefault();
    }
  });

  $("#reset_password").on("submit", function(event) {
    if (!$("#capital-icon").hasClass("valid") || !$("#number-icon").hasClass("valid") || !$("#symbol-icon").hasClass("valid")) {
      event.preventDefault();
    }
  });
});
