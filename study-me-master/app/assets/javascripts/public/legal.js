$(function() {
    $("#researchers").on('click', function() {

      $("#rs").toggleClass("active");
      $("#researchers").toggleClass('selected-section-faq');
      $("#researcher-faq").slideToggle();

    });

    $("#participants").on('click', function() {

      $("#ps").toggleClass("active");
      $("#participants").toggleClass('selected-section-faq');
      $("#participant-faq").slideToggle();

    });
});
