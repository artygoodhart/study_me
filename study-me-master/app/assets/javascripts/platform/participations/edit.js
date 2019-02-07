$(function() {
  checkDate();

  $("#our_table td").mousedown(function () {

    //Colors in a timeslot that is clicked on.
    if ( $(this).hasClass("highlighted") ) {

      // This Un - Toggles the red background when a different timeslot is clicked.
      if ( ($("#our_table").attr("is-highlighted") == "yes")  ) {
        for (var i = ($("#our_table").attr("start-pos")); i < ($("#our_table").attr("end-pos")); i++) {
          $('#our_table tr td:nth-child(' + $("#our_table").attr("x-pos") + ')').eq(i).removeClass("red-highlighted");
        }
      }

      var timeslot_id =  $(this).data("timeslot-id");
      var xpos = $(this).attr("x-pos");
      var fromPos = $(this).attr("start-pos");
      var toPos = $(this).attr("end-pos");
      var date = $("td span").eq(xpos - 1).attr("data-date");
      for (var j = (fromPos); j < (toPos); j++) {
        $('#our_table tr td:nth-child(' + xpos + ')').eq(j).addClass("red-highlighted");
      }
      $("#edit_participation_form").find("#participation_timeslot_id").val(timeslot_id);
      $("#our_table").attr("is-highlighted", "yes").attr("start-pos", fromPos).attr("end-pos", toPos).attr("x-pos", xpos).attr("date", date);
      $(".cal-times").css( "top", 326 );
      $(".continue-button").css("display", "block");
      $(".continue-button").on("click", function(){
        $(".modal-dialog").fadeIn();
      });
      $(".cancel-button").on("click", function(){
        $(".modal-dialog").fadeOut();
      });
      var actual_start_time = document.Time[fromPos];
      var actual_end_time = document.Time[toPos];

      $("#times").html( date + " " + actual_start_time + " - " + actual_end_time );
    }
  })
});


function checkDate() {
  document.start_of_week = $("td span").eq(0).attr("data-date");
  document.end_of_week = $("td span").eq(6).attr("data-date");
  //Checks wether the current day is more recent than the start of the week,
  //To avoid populating days in the past.

  var start_of_week;
  Today = moment().format("MMMM DD, YYYY");
  start_of_week_used = new Date(document.start_of_week);
  var now = new Date();
  now.setHours(0,0,0,0);


  if (start_of_week_used < now) {
    document.start_of_week_used = Today;
  } else {
    document.start_of_week_used = document.start_of_week;
  }
  participantRequest();
}

function participantRequest() {
  $.ajax({
    url: window.location.href,
    type: "GET",
    data: {
      page: {
        date_from: document.start_of_week
      }
    },
    dataType: "json",
    success: function(response) {
      document.participant_timeslots = response;

      if (typeof(document.participant_timeslots) != 'undefined') {
        fillPTable();
      }

    }
  });
}


function fillPTable() {
  var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];
  var from, fromTime, fromPos, to, toTime, toPos, dateNeat, xpos;

  for (var i = 0; i < document.participant_timeslots.length; i++) {

    from = new Date(document.participant_timeslots[i].from);
    to = new Date(document.participant_timeslots[i].to);

    daylightSaving = from.getTimezoneOffset();

    fromTime = from.getHours() + ":" + (from.getMinutes()<10?'0':'') + from.getMinutes();
    toTime = to.getHours() + ":" + (to.getMinutes()<10?'0':'') + to.getMinutes();

    dateNeat = moment(from).format('MMMM DD, YYYY');

    if (daylightSaving === -60) {
      fromTime = (from.getHours() - 1) + ":" + (from.getMinutes()<10?'0':'') + from.getMinutes();
      toTime = (to.getHours() - 1) + ":" + (to.getMinutes()<10?'0':'') + to.getMinutes();
    }

    newTimeslot = {};
    newTimeslot.fromTime = fromTime;
    newTimeslot.toTime = toTime;
    newTimeslot.dateNeat = dateNeat;
    newTimeslot.id = document.participant_timeslots[i].id;
    // window.timeslots[newTimeslot.id] = newTimeslot;
    fromPos = $.inArray(fromTime, document.Time);
    toPos = $.inArray(toTime, document.Time);



    for ( var j = 0; j < 7; j++) {
      if (newTimeslot.dateNeat === $("td span").eq(j).attr("data-date")) {
        xpos = j + 1;
        break;
      } else {
        xpos = -1;
      }
    }

    var middleY = Math.floor((fromPos + toPos) / 2) + 1;
    $('#our_table tr td:nth-child(' + xpos + ')').eq(fromPos).addClass("border-top");


    for (var j = (fromPos); j < (toPos); j++) {
      $("p[data-id-text='" + newTimeslot.id + "']").remove();
      $('#our_table tr td:nth-child(' + xpos + ')').eq(j).toggleClass("highlighted no-borders");
      $('#our_table tr td:nth-child(' + xpos + ')').eq(j).data('timeslot-id', newTimeslot.id);
      $('#our_table tr td:nth-child(' + xpos + ')').eq(j).attr("start-pos", fromPos).attr("end-pos", toPos).attr("x-pos", xpos);
      $('#our_table tr:nth-child(' + middleY + ') td:nth-child(' + xpos + ')').append( '<p data-id-text="' + newTimeslot.id + '" class="in-cell-time">' + fromTime + " - " + toTime + '</p>');
    }
  }
}
