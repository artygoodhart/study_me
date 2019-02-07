//= require_tree ./charts
$.ajax({
  url: window.location.href + '/stats',
  type: "GET",
  dataType: "json",
  success: function(response) {
    if ($.isEmptyObject(response)) {
      return false
    }
    var under_eighteen = eighteen_twentyfive = twentyfive_thirtyfive = thirtyfive_fifty = fifty_plus = 0;
    var min_age, max_age;
    var perc_male, perc_female;
    var total = response.genders.male + response.genders.female;
    lineChart(response.participations);
    $.each( response.participants, function( key, value ) {
      console.log(response.participants.scale);
    });

    $.each( response.genders, function( key, value ) {
      // response.genders.male;

      perc_male = (response.genders.male / total ) * 100;
      perc_female = (response.genders.female / total ) * 100;

    });
    gender_doughnut(perc_male, perc_female);
    $.each( response.ages, function( key, value ) {

      if (key < 18) {
        under_eighteen += value;
      }
      else if (key < 25) {
        eighteen_twentyfive += value;
      }
      else if (key < 35) {
        twentyfive_thirtyfive += value;
      }
      else if (key < 50) {
        thirtyfive_fifty += value;
      }
      else {
        fifty_plus += value;
      }
    });
    age_doughnut(under_eighteen, eighteen_twentyfive, twentyfive_thirtyfive, thirtyfive_fifty, fifty_plus);

    $('#amount-participated').height($('#age-range').height());

    $('#particpants-total').height($('#gender-split').height() - $('#line-graph').height());
    $('#mean-age').height($('#gender-split').height() - $('#line-graph').height());
    var line_height =  ($('#gender-split').height() - $('#line-graph').height())-64;
    $('#mean-age-number').css("line-height", line_height+"px");
    $('#add-non-user').css("line-height", (line_height - 72)/3+"px");
    $('#add-non-user-button').css("line-height", 72+"px");
  }
});

$(function() {
  $('#study_pdf_attachment').on('change', function() {
    var file_name = $("#study_pdf_attachment").val().split('\\').pop()
    console.log($("#study_pdf_attachment").val().split('\\').pop());
    $('#pdf-upload-text').text(file_name);
    $('#pdf-upload-text').toggleClass('upload-selected')
  });

  $('#add-non-user-button').on('click', function() {
    $('.modal-dialog').fadeIn();
  })

  $('#close-modal-button').on('click', function() {
    $('.modal-dialog').fadeOut();
  })

  $('#new_non_user_participant').bind('ajax:complete', function(event, xhr, status) {
    $('#rd-in-modal').slideToggle('slow');
    $('#mor-in-modal').slideToggle('slow');
    $('#dob-in-modal').slideToggle('slow');
    $('#gender-in-modal').slideToggle('slow');
    $('#new_non_user_participant').trigger('reset');
    $('#gender-in-modal').slideToggle('slow');
    $('#dob-in-modal').slideToggle('slow');
    $('#mor-in-modal').slideToggle('slow');
    $('#rd-in-modal').slideToggle('slow');
  })

  $('#choose-participations').on('click', function(){

    var form;
    form = $(this)

    form.submit;
  })

});
