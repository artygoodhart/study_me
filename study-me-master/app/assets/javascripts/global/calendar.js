var currentDay = parseInt(moment().format('D'));
var firstDayOfWeek = parseInt(moment().startOf('isoweek').format('D'));
document.daysToGreyOut = currentDay - firstDayOfWeek;
var newWeek = 0;
var i;
var cellsWhite = false;

document.Time = [ "8:00","8:15","8:30","8:45","9:00","9:15","9:30","9:45","10:00","10:15","10:30","10:45","11:00",
"11:15","11:30","11:45","12:00","12:15","12:30","12:45","13:00","13:15","13:30","13:45","14:00",
"14:15","14:30","14:45","15:00","15:15","15:30","15:45","16:00","16:15","16:30","16:45","17:00",
"17:15","17:30","17:45","18:00","18:15","18:30","18:45","19:00" ];

$(function () {

  for (i = 0; i<=document.daysToGreyOut; i++) {
    $('table tr td:nth-child('+i+')').toggleClass("greyed-out");
  }

  // Populating the calendar with the correct dates.

  $("#start-day").append(moment().startOf('isoweek').format('Do'));
  $("#end-day").append(moment().endOf('isoweek').format('Do'));
  $("#start-month").append(moment().startOf('isoweek').format('MMMM'));
  $("#end-month").append(moment().endOf('isoweek').format('MMMM'));


  $("#date1").append(moment().startOf('isoweek').format('Do'));
  $("#date1").attr("data-date", moment().startOf('isoweek').format('MMMM DD, YYYY'));
  $("#date2").append(moment().startOf('isoweek').add(1, 'days').format('Do'));
  $("#date2").attr("data-date", moment().startOf('isoweek').add(1, 'days').format('MMMM DD, YYYY'));
  $("#date3").append(moment().startOf('isoweek').add(2, 'days').format('Do'));
  $("#date3").attr("data-date", moment().startOf('isoweek').add(2, 'days').format('MMMM DD, YYYY'));
  $("#date4").append(moment().startOf('isoweek').add(3, 'days').format('Do'));
  $("#date4").attr("data-date", moment().startOf('isoweek').add(3, 'days').format('MMMM DD, YYYY'));
  $("#date5").append(moment().startOf('isoweek').add(4, 'days').format('Do'));
  $("#date5").attr("data-date", moment().startOf('isoweek').add(4, 'days').format('MMMM DD, YYYY'));
  $("#date6").append(moment().startOf('isoweek').add(5, 'days').format('Do'));
  $("#date6").attr("data-date", moment().startOf('isoweek').add(5, 'days').format('MMMM DD, YYYY'));
  $("#date7").append(moment().startOf('isoweek').add(6, 'days').format('Do'));
  $("#date7").attr("data-date", moment().startOf('isoweek').add(6, 'days').format('MMMM DD, YYYY'));

  $("#right-click").on("click", function() {
    newWeek++;
    changing_week();
    checkDate();

  });

  $("#left-click").on("click", function() {
    if (newWeek >= 1) {
      newWeek--;
      changing_week();
      checkDate();


      if (newWeek === 0){
        var i;
        $('table tr td').removeClass("white-background");
        for (i = 0; i<=document.daysToGreyOut; i++) {
          $('table tr td:nth-child('+i+')').toggleClass("greyed-out");
          $('#our_table td:nth-child('+i+')').html("");
        }
        cellsWhite = false;
      }
    }
  });

  function changing_week() {
    clear_table();
    //Participant Calendar Check if selected time slot is in week and toggle it.
    if (!cellsWhite) {
      for (i = 0; i<=document.daysToGreyOut; i++) {
        $('table tr td:nth-child('+i+')').toggleClass("greyed-out");
      }
      cellsWhite = true;
    }

    $('.date').empty();
    $("#start-day").empty();
    $("#end-day").empty();
    $("#start-month").empty();
    $("#end-month").empty();

    $("#start-day").append(moment().startOf('isoweek').add((newWeek)*7, 'days').format('Do'));
    $("#end-day").append(moment().endOf('isoweek').add((newWeek)*7, 'days').format('Do'));
    $("#start-month").append(moment().startOf('isoweek').add((newWeek)*7, 'days').format('MMMM'));
    $("#end-month").append(moment().endOf('isoweek').add((newWeek)*7, 'days').format('MMMM'));

    $("#date1").append(moment().startOf('isoweek').add((newWeek)*7, 'days').format('Do'));
    $("#date1").attr("data-date", moment().startOf('isoweek').add((newWeek)*7, 'days').format('MMMM DD, YYYY'));
    $("#date2").append(moment().startOf('isoweek').add((newWeek)*7 + 1, 'days').format('Do'));
    $("#date2").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 1, 'days').format('MMMM DD, YYYY'));
    $("#date3").append(moment().startOf('isoweek').add((newWeek)*7 + 2, 'days').format('Do'));
    $("#date3").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 2, 'days').format('MMMM DD, YYYY'));
    $("#date4").append(moment().startOf('isoweek').add((newWeek)*7 + 3, 'days').format('Do'));
    $("#date4").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 3, 'days').format('MMMM DD, YYYY'));
    $("#date5").append(moment().startOf('isoweek').add((newWeek)*7 + 4, 'days').format('Do'));
    $("#date5").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 4, 'days').format('MMMM DD, YYYY'));
    $("#date6").append(moment().startOf('isoweek').add((newWeek)*7 + 5, 'days').format('Do'));
    $("#date6").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 5, 'days').format('MMMM DD, YYYY'));
    $("#date7").append(moment().startOf('isoweek').add((newWeek)*7 + 6, 'days').format('Do'));
    $("#date7").attr("data-date", moment().startOf('isoweek').add((newWeek)*7 + 6, 'days').format('MMMM DD, YYYY'));

    document.start_of_week = moment($("td span").eq(0).attr("data-date"));
    document.end_of_week = moment($("td span").eq(6).attr("data-date"));

    //colors in the user selected timeslot if its in the correct week

    var fromPos = $("#our_table").attr("start-pos");
    var toPos = $("#our_table").attr("end-pos");
    var xpos = $("#our_table").attr("x-pos");
    var date = moment($("#our_table").attr("date"));

    if ( date.valueOf() >= document.start_of_week.valueOf() && date.valueOf() <= document.end_of_week.valueOf() ) {

      for (var i = (fromPos); i < (toPos); i++) {
        $('#our_table tr td:nth-child(' + xpos + ')').eq(i).addClass("red-highlighted");
      }

    }

  }

  function clear_table() {
    $('#our_table p[class="in-cell-time"]').remove();
    $('#our_table *[class="slide-button-styling"]').remove();
    $('#our_table *[class="calendar-button-styling"]').remove();
    $('td').removeClass("border-top");
    $("td").removeClass('red-highlighted highlighted no-borders');
  }
});
