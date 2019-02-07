$(function() {
  $('#study_background_photo').on('change', function() {
    var file_name = $("#study_background_photo").val().split('\\').pop()
    $('#photo-upload-text').text(file_name);
    $('#photo-upload-text').toggleClass('upload-selected')
  });
});
