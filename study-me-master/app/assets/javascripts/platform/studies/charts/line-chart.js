function lineChart(response) {
  var signUpDates = response.study_me.dates;
  var externalDates = response.external.dates;
  var counter = 0;
  var total = Object.keys(signUpDates).length;

  var arr_dates_signed_up = [];

  for (var key in signUpDates) {
    if (signUpDates.hasOwnProperty(key)) {
      arr_dates_signed_up.push(key);
    }
  }

  function upDateData () {
    for (var i = 0; i < Object.keys(signUpDates).length; i++) {
      line_chart.data.datasets[0].data[i] = signUpDates[arr_dates_signed_up[i]];
      if (Object.keys(signUpDates).length > Object.keys(externalDates).length) {
        line_chart.data.labels[i] = dateIfy(response.study_me.scale, arr_dates_signed_up[i]);
      }
    }

    for (var i = 0; i < Object.keys(externalDates).length; i++) {
      line_chart.data.datasets[1].data[i] = externalDates[arr_dates_signed_up[i]];
      if (Object.keys(signUpDates).length <= Object.keys(externalDates).length) {
        line_chart.data.labels[i] = dateIfy(response.external.scale, arr_dates_signed_up[i]);
      }
    }

    console.log(line_chart.data.datasets[0].data);
    console.log(line_chart.data.datasets[1].data);

    line_chart.update();
  }

  function dateIfy (scale, date) {
    if (scale == 'day') {
      return moment(date).format("MMM D");
    } else {
      var dateArray, dateObject;
      dateArray = date.split('-');
      dateObject = moment();

      dateObject.year(dateArray[0]);
      dateObject.week(dateArray[1]);
      dateObject.day(1);

      return dateObject.format("MMM D");
    }
  }

  var data = {
    labels: [],
    datasets: [
      {
        label: 'Study Me',
        fill: false,
        lineTension: 0.2,
        backgroundColor: "white",
        borderColor: "white",
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointRadius: 0,
        data: [],
        spanGaps: false,
      },
      {
        label: 'External',
        fill: false,
        lineTension: 0.2,
        backgroundColor: "#4A4A4A",
        borderColor: "#4A4A4A",
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointRadius: 0,
        data: [],
        spanGaps: false,
      }
    ]
  };

  var ctx = document.getElementById("line_chart");
  var line_chart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
      legend: {
        display: true
      },
      responsive: true,
      scales: {
        xAxes: [{
          ticks: {
            display: true
          },
          gridLines: {
            color: "rgba(0, 0, 0, 0)",
          }
        }],
        yAxes: [{
          stacked: false,
          ticks: {
            display: true,
            stepSize: 1
          },
          gridLines: {
            color: "rgba(0, 0, 0, 0)",
          }
        }]
      }
    }
  });

  upDateData();
}
