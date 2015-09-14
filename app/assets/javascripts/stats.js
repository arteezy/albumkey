$(document).on("ready page:load", function() {
  if (document.location.pathname.startsWith("/stats"))
    $.ajax({
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: document.location.pathname,
      dataType: "json",
      success: function (data) {
        AmCharts.makeChart("chartid",
          {
            "type": "serial",
            "categoryField": "_id",
            "dataDateFormat": "YYYY-MM-DD",
            "theme": "dark",
            "categoryAxis": {
              "parseDates": true
            },
            "chartCursor": {},
            "chartScrollbar": {
              "backgroundColor": "#9400D3",
              "dragIcon": "dragIconRectBigBlack",
              "dragIconHeight": 30,
              "dragIconWidth": 30
            },
            "trendLines": [],
            "graphs": [
              {
                "bullet": "bubble",
                "bulletSize": 5,
                "gapPeriod": 1,
                "id": "AVGDR",
                "lineThickness": 2,
                "precision": 2,
                "stepDirection": "center",
                "title": "Rating",
                "type": "smoothedLine",
                "valueField": "avg_rating",
                "visibleInLegend": false
              }
            ],
            "guides": [],
            "valueAxes": [
              {
                "id": "ValueAxis-1",
                "maximum": 10,
                "minimum": 0,
                "title": "Average Rating"
              }
            ],
            "allLabels": [],
            "balloon": {},
            "legend": {
              "useGraphSettings": true
            },
            "titles": [
              {
                "id": "Title-1",
                "size": 15,
                "text": "Average Daily Rating"
              }
            ],
            "dataProvider": data
          }
        );

        var avg_rating = data.map(function(d) { return d.avg_rating.toFixed(2); });
        draw(avg_rating);
      },
      error: function (result) {
        error();
      }
    });

  function draw(data) {
    var color = d3.scale.category10();
    var height = 300, barWidht = 2;

    var x = d3.scale.linear()
      .range([height, 0])
      .domain([0, 10]);

    var xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom');

    var chart = d3.select("#graph")
      .attr("height", height)
      .attr("width", barWidht * data.length);

    var bar = chart.selectAll("g")
      .data(data)
      .enter().append("g")
      .attr("transform", function (d, i) {
        return "translate(" + i * barWidht + ",0)";
      });

    bar.append("rect")
      .attr("height", function(d) {
        return height - x(d);
      })
      .attr("width", barWidht - 1)
      .attr("y", x)
      .attr("class", "bar")
      .style("fill", function (d) {
        return color(d)
      })

    chart.append('g')
      .attr('class', 'x axis')
      .attr("transform", "translate(0," + (height - 40) + ")")
      .call(xAxis);
  }

  function error() {
    console.log("error drawing d3 graph")
  }
});
