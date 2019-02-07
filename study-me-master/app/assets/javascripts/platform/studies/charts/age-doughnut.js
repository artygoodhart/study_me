function age_doughnut(under_eighteen, eighteen_twentyfive, twentyfive_thirtyfive, thirtyfive_fifty, fifty_plus) {
  var ctx = document.getElementById("doughnut_chart_age");

  var myChart = new Chart(ctx, {
    type: 'doughnut',
    options: {
      cutoutPercentage: 60,
      title: {
        display: false
      },
      legend: {
        labels: {
          boxWidth: 15,
          fontSize: 15,
          fontColor: "#000",
          fontStyle: "Lato"
        }
      }
    },
    data: {
      labels: ["0-17", "18-25", "26-35", "36-50", "50+"],

      datasets: [{
        backgroundColor: [
          "#2980b9",
          "#8e44ad",
          "#27ae60",
          "#2c3e50",
          "#c0392b"
        ],
        data: [under_eighteen, eighteen_twentyfive, twentyfive_thirtyfive, thirtyfive_fifty, fifty_plus]
      }]
    }
  });
}
