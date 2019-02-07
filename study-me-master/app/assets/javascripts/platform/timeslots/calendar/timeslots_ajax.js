

// timeslot {
//   from: document.start_time;
//   to: document.end_time;
// }

$(function () {
  window.timeslots = {};
  if ($(".calendar").is(":visible")) {
    $(document).mouseup(function (event) {
      if (!$(event.target).is("button") && typeof(document.timestart) != "undefined") {
        var postToDatabase = true;

        $.each(timeslots, function( i, value ) {
          if (value !== null) {
            if (document.date === value.dateNeat) {
              var start_time = $.inArray(value.fromTime, document.Time);
              var end_time = $.inArray(value.toTime, document.Time);
              if (document.original_y_pos>=start_time && document.original_y_pos<end_time) {
                postToDatabase = false;
                return;
              }
            }
          }
        });

        if (!postToDatabase) {
          console.log("No object");
          return;
        }


        $.ajax({
          url: "/studies/" + $("#our_table").data('study') + "/timeslots",
          type: "POST",
          data: {
            timeslot: {
              start_time: document.timestart,
              end_time: document.timeEnd,
              date: document.date
            }
          },
          dataType: "json",
          success: function(response) {
            var newTimeslot, from, fromTime, to, toTime, dateNeat;

            from = new Date(response.from);
            to = new Date(response.to);
            daylightSaving = from.getTimezoneOffset();



            var monthNames = ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];

            fromTime = from.getHours() + ":" + (from.getMinutes()<10?'0':'') + from.getMinutes();
            toTime = to.getHours() + ":" + (to.getMinutes()<10?'0':'') + to.getMinutes();
            dateNeat = monthNames[(from.getMonth())] + " " + (from.getDate()<10?'0':'') + to.getDate() + ", " + from.getFullYear();
            if (daylightSaving === -60) {
              fromTime = (from.getHours() - 1) + ":" + (from.getMinutes()<10?'0':'') + from.getMinutes();
              toTime = (to.getHours() - 1) + ":" + (to.getMinutes()<10?'0':'') + to.getMinutes();
            }

            newTimeslot = new Object();
            newTimeslot.fromTime = fromTime;


            newTimeslot.toTime = toTime;
            newTimeslot.dateNeat = dateNeat;
            newTimeslot.id = response.id;
            window.timeslots[newTimeslot.id] = newTimeslot;

            var fromPos = $.inArray(fromTime, document.Time);
            var toPos = $.inArray(toTime, document.Time);
            var middleY = Math.floor((fromPos + toPos) / 2) + 1;

            for ( var j = 0; j < 7; j++) {
              if (dateNeat === $("td span").eq(j).attr("data-date")) {
                var xpos = j + 1;
                break;
              } else {
                xpos = -1;
              }
            }

            $('.calendar tr td:nth-child(' + xpos + ')').eq(fromPos).append( '<button data-id-button="' + newTimeslot.id + '" class="calendar-button-styling">X</button>' );
            // $('table tr:nth-child('+middleY+') td:nth-child(' + xpos + ')').remove();
            $('td:nth-child(' + xpos + ') p[data-id-text="' + fromPos + " " + (toPos -1) + '"]').attr("data-id-text", newTimeslot.id);
            // $('table tr td:nth-child(' + xpos + ') p[data-id-text="' + fromPos + " " + (toPos -1) + ']"').remove();
            $('p[id="time-text' + document.timeslotCounter + '"]').remove();
            $('#our_table tr:nth-child(' + middleY + ') td:nth-child(' + xpos + ')')
            .append( '<p data-id-text="' + newTimeslot.id + '" class="in-cell-time">' +
            fromTime + " - " + toTime + '</p>');

            document.timestart = undefined;
            document.timeslotCounter++;

          },
          error: function(response) {
            console.log(response);
          }
        });
      }
    });
  }
});
