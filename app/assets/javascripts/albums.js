function getQueryParams(qs) {
  qs = qs.split('+').join(' ');
  var params = {}, tokens, re = /[?&]?([^=]+)=([^&]*)/g;
  while (tokens = re.exec(qs)) {
    params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
  }
  return params;
}

$(document).on("ready page:load", function() {
  $("#filter").submit(function() {
    $(this).find(":input").filter(function(){ return !this.value; }).attr("disabled", "disabled");
    return true;
  });

  $.get('/api/artists.json', function(data){
      $("#dank").typeahead({ source:data });
  },'json');

  $("#dash").affix({
    offset: {
      top: $(".navbar-header").height()
    }
  });

  var rating = 7.5;
  var query = getQueryParams(document.location.search);
  if (query.rating) rating = +query.rating;

  $("#rating").slider({
    min: 0,
    max: 10,
    step: 0.1,
    value: rating,
    handle: 'round'
  });

  $(".slider").mouseenter(function() {
    $("#rating").removeAttr("disabled");
  });

  $(function () {
    $(".rating.user").mouseenter(function() {
      $(this).removeClass("dim");

      $(this).mousemove(function(e) {
        $(this).text(((this.offsetHeight - e.offsetY) / this.offsetHeight * 10.0).toFixed(1));
      });

      $(this).mouseleave(function() {
        $(this).text("0.0");
        $(this).addClass("dim");
      });
    });

    $(".rating.user").mouseleave(function() {
      $(this).off("mousemove");
    });

    $(".rating.user").mousedown(function() {
      var rate = $(this).text();
      var album_id = $(this).closest(".card").data("album-id");
      $.ajax({
        url: '/api/rate/' + album_id,
        type: 'POST',
        data: 'rate=' + rate,
        error: function(e) {
          console.log("Can't rate album: " + e.message);
        }
      });
    });

    $(".rating.user").mouseup(function() {
      $(this).off("mousemove");
      $(this).off("mouseleave");
      $(this).removeClass("dim");
    });
  });
});
