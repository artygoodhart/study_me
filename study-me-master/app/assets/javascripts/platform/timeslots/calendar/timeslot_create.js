document.Time = [ "8:00","8:15","8:30","8:45","9:00","9:15","9:30","9:45","10:00","10:15","10:30","10:45","11:00",
"11:15","11:30","11:45","12:00","12:15","12:30","12:45","13:00","13:15","13:30","13:45","14:00",
"14:15","14:30","14:45","15:00","15:15","15:30","15:45","16:00","16:15","16:30","16:45","17:00",
"17:15","17:30","17:45","18:00","18:15","18:30","18:45","19:00" ];

$(function () {

  var isMouseDown = false,
  isHighlighted;

  // $('.dates table tbody tr td p.in-cell-time').html("");

  $('td').on("click", "button", function () {
    var xpos = $(this).parent().index() + 1;
    var timeslot_id = $(this).attr("data-id-button");
    var startTime = timeslots[timeslot_id].fromTime;
    var endTime = timeslots[timeslot_id].toTime;
    for (i = ($.inArray(startTime, document.Time)); i < ($.inArray(endTime, document.Time)); i++)  {
      $(this).remove();
      $("p[data-id-text='" + timeslot_id + "']").remove();
      $('#our_table tr td:nth-child('+ xpos +')').eq(i).toggleClass("highlighted no-borders");
      $('#our_table tr td:nth-child('+ xpos +')').eq(i).removeClass("border-top");
    }

    //Ajax that deletes the id from the database
    $.ajax({
      url: "/studies/" + $("#our_table").data('study') + "/timeslots/" + timeslot_id,
      method: "delete",

      success: function(response) {
        timeslots[timeslot_id] = null;
      }
    });
  });

  $("#our_table td").mousedown(function () {

    document.date = $("td span").eq(($(this).index())).attr("data-date");

    //Checks wether the background is grey of green already.
    if (!$(this).hasClass("highlighted") && !$(this).hasClass("greyed-out")) {
      document.x_pos = ($(this).index())+1;
      document.original_y_pos = $(this).parent().index();
      document.timestart = document.Time[document.original_y_pos];
      document.timeEnd = document.Time[document.original_y_pos + 1];
      isMouseDown = true;

      //Adds appropriate text and button and toggles class when any cell is clicked
      $('#our_table tr td:nth-child('+ document.x_pos +')').eq(document.original_y_pos).addClass("highlighted no-borders");
      $('#our_table tr td:nth-child('+ document.x_pos +')').eq(document.original_y_pos).append( '<p id="time-text' + document.timeslotCounter + '" class="in-cell-time">'+document.timestart+" - "+document.timeEnd+ '</p>' );
      $('#our_table tr td:nth-child('+ document.x_pos +')').eq(document.original_y_pos).addClass("border-top");

      //Checks cell below is highlighted and impliments border
      // if ($('#our_table tr td:nth-child(' + document.x_pos + ')').eq(document.original_y_pos+2).hasClass("highlighted")) {
      //   $('#our_table tr td:nth-child(' + document.x_pos + ')').eq(document.original_y_pos+2).addClass("border-top");
      // }

    }
    return false;
  })
  // Toggles the background and adds the bottom slider when user hold mouse down and drags
  .hover(function () {
    var check_x_pos = ($(this).index())+1;
    document.new_y_pos = $(this).parent().index();

    if (isMouseDown) {
      var i;

      document.middleY = Math.floor((document.original_y_pos + document.new_y_pos)/2) + 1;

      document.timeEnd = document.Time[Math.max(document.new_y_pos, document.original_y_pos) + 1];
      //checks cell below
      if ($('#our_table tr:nth-child('+(document.new_y_pos + 2)+') td:nth-child('+document.x_pos+')').hasClass("highlighted")) {
        isMouseDown = false;
      }

      var currentYPos = -1;
      currentYPos = event.pageY;
      var height = $(window).height() + $(window).scrollTop();
      document.yDistanceFromBottom = height - currentYPos;

      if (document.yDistanceFromBottom < 50 ) {
        $('html, body').animate({scrollTop: '+=50px'}, 500 , "linear");
        $('html, body').clearQueue();
      };

      //For loop toggles background color for cells between original and new mouse position
      for (i = document.original_y_pos; i < document.new_y_pos; i++)  {
        $('p[id="time-text' + document.timeslotCounter + '"]').remove();
        $('*[id="slide-id' + document.timeslotCounter + '"]').remove();
        $('#our_table tr td:nth-child('+document.x_pos+')').eq(i+1).toggleClass("highlighted no-borders");
        $('#our_table tr:nth-child('+document.middleY+') td:nth-child('+document.x_pos+')')
          .append( '<p data-id-text="' + document.original_y_pos+ " " +
          document.new_y_pos + '" id="time-text' +
          document.timeslotCounter + '" class="in-cell-time">' +
          document.timestart + " - " + document.timeEnd + '</p>');
      }
      // if (document.original_y_pos === document.new_y_pos) {
      //   $('#our_table tr:nth-child('+document.middleY+') td:nth-child('+document.x_pos+')')
      //     .html( '<p data-id-text="' + document.original_y_pos+ " " +
      //     document.new_y_pos + '" id="time-text' +
      //     document.timeslotCounter + '" class="in-cell-time">' +
      //     document.timestart + " - " + document.timeEnd + '</p>');
      //
      // }
      // if (!$('#our_table tr td:nth-child('+(document.x_pos)+')').eq(document.original_y_pos+1).hasClass("border-top")) {
      //   $('#our_table tr td:nth-child('+(document.x_pos)+')').eq(document.original_y_pos+1).removeClass("highlighted");
      // }


    }
  })

  $(document).mouseup(function (event) {
    isMouseDown = false;

  });
});
