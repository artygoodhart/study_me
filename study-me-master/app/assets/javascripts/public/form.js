$(function() {
  $(".field").on("focus", function() {
    $(this).animate({
      width: "100%"
    }, 500);
  });


  $(".field").on("focusout", function() {
    if ($(this).val() == "") {
      $(this).animate({
        width: "50%"
      }, 500, function() {
        $(this).css("width", "")
      });
    }
  });

  $("input").on("input", function() {
    updateSendButton();
  });

  $("textarea").on("input", function() {
    updateSendButton();
  });

  $("#new_contact").on("submit", function(event) {
    if (!fieldsArentEmpty()) {
      event.preventDefault();
      event.stopPropagation();
    }
  });
});

function updateSendButton() {
  if (fieldsArentEmpty()) {
    $("#contact_submit").css({
      "color": "rgba(0, 0, 0, 0.54)",
      "cursor": "pointer"
    });
  } else {
    $("#contact_submit").css({
      "color": "rgba(0, 0, 0, 0.12)",
      "cursor": "default"
    });
  }

  $(".error.field").slideUp();
}

function fieldsArentEmpty() {
  var name, email, message;

  name = $("#contact_name");
  email = $("#contact_email");
  message = $("#contact_message");

  return name.val() != "" && email.val() != "" && message.val() != "";
}
