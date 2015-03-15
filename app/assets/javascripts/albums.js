$(document).on("ready page:load", function() {
  $("#filter").submit(function() {
    $(this).find(":input").filter(function(){ return !this.value; }).attr("disabled", "disabled");
    return true;
  });

  $(function () {
    $("div.score").mouseenter(function() {
      $(this).removeClass("dim");

      $(this).mousemove(function(e) {
        $(this).text(((this.offsetTop + this.offsetHeight - e.pageY) / this.offsetHeight * 10.0).toFixed(1));
        // $(this).text(((e.pageX - this.offsetLeft) / this.offsetWidth * 10.0 + 0.1).toFixed(1));
      });

      $(this).mouseleave(function() {
        $(this).text("0.0");
        $(this).addClass("dim");
      });
    });

    $("div.score").mouseleave(function() {
      $(this).off("mousemove");
    });

    $("div.score").mouseup(function() {
      $(this).off("mousemove");
      $(this).off("mouseleave");
      $(this).removeClass("dim");
    });
  });
});
