function gender_doughnut(perc_male, perc_female) {
  perc_male = perc_male.toFixed(1);
  perc_female = perc_female.toFixed(1);
  $("#male_perc").text(perc_male + "%");
  $("#female_perc").text(perc_female + "%");
  var ctx = document.getElementById("doughnut_chart_gender");
  var myChart = new Chart(ctx, {
    type: 'doughnut',
    options: {
      cutoutPercentage: 60,
      title: {
        display: false,
      },
      legend: {
        onClick: function (e) {
          e.stopPropagation();
        }
      }
    },

    data: {
      labels: ["Male", "Female"],
      datasets: [{
        backgroundColor: [
          "#2980b9",
          "#8e44ad"
        ],
        data: [perc_male, perc_female]
      }]
    }
  });
};
