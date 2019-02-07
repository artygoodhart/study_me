document.timeslotCounter = 0;

$(function () {
  checkDate();
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
  newRequest();
}

function newRequest() {
  $.ajax({
    url: "/studies/" + $("#our_table").data('study') + "/timeslots",
    type: "GET",
    data: {
      page: {
        date_from: document.start_of_week_used
      }
    },
    dataType: "json",
    success: function(response) {
      window.databaseTimeslots = response;
      if (typeof(window.databaseTimeslots) != 'undefined') {
        fillTable();
      }
    }
  });
}

function fillTable() {
  var monthNames = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"];
  var from, fromTime, fromPos, to, toTime, toPos, dateNeat, xpos;

  for (var i = 0; i < window.databaseTimeslots.length; i++) {
    from = new Date(databaseTimeslots[i].from);
    to = new Date(databaseTimeslots[i].to);

    fromTime = from.getHours() + ":" + (from.getMinutes()<10?'0':'') + from.getMinutes();
    toTime = to.getHours() + ":" + (to.getMinutes()<10?'0':'') + to.getMinutes();
    dateNeat = moment(from).format('MMMM DD, YYYY');

    newTimeslot = {};
    newTimeslot.fromTime = fromTime;
    newTimeslot.toTime = toTime;
    newTimeslot.dateNeat = dateNeat;
    newTimeslot.id = window.databaseTimeslots[i].id;
    window.timeslots[newTimeslot.id] = newTimeslot;

    console.log(newTimeslot);

    fromPos = $.inArray(fromTime, document.Time);
    toPos = $.inArray(toTime, document.Time)

    for ( var j = 0; j < 7; j++) {
      if (newTimeslot.dateNeat === $("td span").eq(j).attr("data-date")) {
        xpos = j + 1;
        break;
      } else {
        xpos = -1;
      }
    }

    var middleY = Math.floor((fromPos + toPos) / 2) + 1;
    $('#our_table tr td:nth-child(' + xpos + ')').eq(fromPos).append( '<button data-id-button="' + newTimeslot.id + '" class="calendar-button-styling">X</button>' );
    $('#our_table tr td:nth-child(' + xpos + ')').eq(fromPos).addClass("border-top");


    for (var j = (fromPos); j < (toPos); j++) {
      $("p[data-id-text='" + newTimeslot.id + "']").remove();
      $('*[id="slide-id' + document.timeslotCounter + '"]').remove();
      $('#our_table tr td:nth-child(' + xpos + ')').eq(j).toggleClass("highlighted no-borders");
      $('#our_table tr:nth-child(' + middleY + ') td:nth-child(' + xpos + ')').append( '<p data-id-text="' + newTimeslot.id + '" class="in-cell-time">' + fromTime + " - " + toTime + '</p>');
    }
    document.timeslotCounter++;
  }
}

//Loop over databaseTimeslots Render them here and create and to the global timeslot array
//for each databaseTimeslots
