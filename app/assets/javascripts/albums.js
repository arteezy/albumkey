$(document).on("ready page:load", function() {
  $("#filter").submit(function() {
    $(this).find(":input").filter(function(){ return !this.value; }).attr("disabled", "disabled");
    return true;
  });

  $(function () {
    $("div.score.user").mouseenter(function() {
      $(this).removeClass("dim");

      $(this).mousemove(function(e) {
        $(this).text(((this.offsetHeight - e.offsetY) / this.offsetHeight * 10.0).toFixed(1));
      });

      $(this).mouseleave(function() {
        $(this).text("0.0");
        $(this).addClass("dim");
      });
    });

    $("div.score.user").mouseleave(function() {
      $(this).off("mousemove");
    });

    $("div.score.user").mousedown(function() {
      var rate = $(this).text();
      var album_id = $(this).closest(".card").data("album-id");
      var jqxhr = $.ajax({
        url: '/rate/' + album_id,
        type: 'POST',
        data: 'rate=' + rate,
        success: function(data) {
          alert("success");
        },
        error: function(e) {
          console.log(e.message);
        }
      });
    });

    $("div.score.user").mouseup(function() {
      $(this).off("mousemove");
      $(this).off("mouseleave");
      $(this).removeClass("dim");
    });
  });
});
