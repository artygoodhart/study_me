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

  // $("input").on("input", function() {
  //   updateSendButton();
  // });
  //
  // $("textarea").on("input", function() {
  //   updateSendButton();
  // });

  $("#new_contact").on("submit", function(event) {
    if (!fieldsArentEmpty()) {
      event.preventDefault();
      event.stopPropagation();
    }
  });
});

$(document).on("keypress", '.requirements', addNewInputField);
$(document).on("blur", '.requirements', deHighlightField);

var counter = 2;
document.indexVar = 0;

function addNewInputField(e) {
  var indexNext = $('.requirements').index(this);
  if ( ($(this).val().length < 1  && (indexNext === document.indexVar))){
    document.indexVar = indexNext + 1;
    var newTextBoxDiv = $(document.createElement('div')).attr({ id: ('TextBoxDiv' + counter), class: "twelve columns form-item"} );
    newTextBoxDiv.after().html(
      '<input class="requirements title-input input-style form" type="text" name="study[requirements_studies][requirement' + counter + '][text]" id="textbox" value="" />' +
      '<div class="check-box">' +
        '<label for="study[requirements_studies][requirement' + counter + '][checked]" class="round checkbox inline">' +
          '<input type="radio" name="study[requirements_studies][requirement' + counter + '][checked]" value="true" class="round checkbox inline" checked="checked" />' +
          '<span>Yes</span>' +
        '</label>' +
      '</div>' +
      '<div class="check-box">' +
        '<label for="study[requirements_studies][requirement' + counter + '][checked]" class="round checkbox inline">' +
          '<input type="radio" name="study[requirements_studies][requirement' + counter + '][checked]" value="false" class="round checkbox inline" />' +
          '<span>No</span>' +
        '</label>' +
      '</div>'
    );
    newTextBoxDiv.appendTo("#TextBoxesGroup");
    counter++;
  }
}

function deHighlightField() {
  console.log("Dehight");
  var index = $('.requirements').index(this);
  $('.requirements').eq(index).css('border-width','0');
}

function highlightField() {
  console.log("Clicked");
  var index = $('.requirements').index(this);
  $('.requirements').eq(index).css('border-width','2px');
}

$(document).ready(function() {
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});
