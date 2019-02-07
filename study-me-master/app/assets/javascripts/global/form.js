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
$(document).on("click", '.requirements', highlightField);

var counter = 2;
document.indexVar = 0;

function addNewInputField(e) {
  var indexNext = $('.requirements').index(this);
  if ( ($(this).val().length < 1  && (indexNext === document.indexVar))){
    document.indexVar = indexNext + 1;
    var newTextBoxDiv = $(document.createElement('div')).attr({ id: ('TextBoxDiv' + counter), class: "twelve columns form-item"} );
    newTextBoxDiv.after().html(
      '<div class="req-input">' +
        '<input class="requirements title-input input-style form" type="text" name="study[requirements_studies][requirement' + counter + '][text]" id="textbox" value="" />' +
      '</div>' +
      '<div class="yes-no">' +
        '<div class="check-box">' +
          '<label for="study[requirements_studies][requirement' + counter + '][checked]" class="round checkbox inline">' +
            '<input type="radio" name="study[requirements_studies][requirement' + counter + '][checked]" value="true" checked="checked" />' +
            '<span>Yes</span>' +
          '</label>' +
        '</div>' +
        '<div class="check-box">' +
          '<label for="study[requirements_studies][requirement' + counter + '][checked]" class="round checkbox inline">' +
            '<input type="radio" name="study[requirements_studies][requirement' + counter + '][checked]" value="false" />' +
            '<span>No</span>' +
          '</label>' +
        '</div>' +
      '</div>'
    );
    newTextBoxDiv.appendTo("#TextBoxesGroup");
    counter++;
  }
}

function deHighlightField() {
  var index = $('.requirements').index(this);
  if ($('.requirements').eq(index).val() === '') {
    $('.requirements').eq(index).css('border-top-color','white');
    $('.requirements').eq(index).css('border-right-color','white');
    $('.requirements').eq(index).css('border-left-color','white');
  } else {
    $('.requirements').eq(index).css('border-color','white');
  }
}

function highlightField() {
  var index = $('.requirements').index(this);
  $('.requirements').eq(index).css('border-color','#1bc7a5');
  // $('.requirements').css('border-bottom-color', '#1bc7a5');
}

$(document).ready(function() {
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});
