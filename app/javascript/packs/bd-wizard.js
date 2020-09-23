$(document).on("turbolinks:load", function () {
  $("#wizard").steps({
    headerTag: "h3",
    bodyTag: "section",
    transitionEffect: "none",
    titleTemplate: "#title#",
    enableFinishButton: false,
  });
});
