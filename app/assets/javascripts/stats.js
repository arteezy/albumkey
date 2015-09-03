$(document).on("ready page:load", function() {
  if (document.location.pathname.startsWith("/stats"))
    $.ajax({
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: document.location.pathname,
      dataType: "json",
      success: function (data) {
        var avg_rating = data.map(function(d) { return d.avg_rating; });
        draw(avg_rating);
      },
      error: function (result) {
        error();
      }
    });

  function draw(data) {
    var color = d3.scale.category20b();
    var width = 420, barHeight = 20;

    var x = d3.scale.linear()
      .range([0, width])
      .domain([0, 10]);

    var chart = d3.select("#graph")
      .attr("width", width)
      .attr("height", barHeight * data.length);

    var bar = chart.selectAll("g")
      .data(data)
      .enter().append("g")
      .attr("transform", function (d, i) {
        return "translate(0," + i * barHeight + ")";
      });

    bar.append("rect")
      .attr("width", x)
      .attr("height", barHeight - 1)
      .style("fill", function (d) {
        return color(d)
      })

    bar.append("text")
      .attr("x", function (d) {
        return x(d) - 25;
      })
      .attr("y", barHeight / 2)
      .attr("dy", ".35em")
      .style("fill", "white")
      .text(function (d) {
        return d;
      });
  }

  function error() {
    console.log("error drawing d3 graph")
  }
});
