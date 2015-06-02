$(function() {
  $('.no').on('click', function(){
    $('textarea').val($('textarea').val() + ">>" + $(this).data('id') + "\n");
  });

  $(".content p").contents().each(function () {
    if (this.nodeType === 3) $(this).replaceWith($.trim($(this).text()).replace(/>>([0-9]+)/g, "<a href=\"#$1\">>>$1</a>"));
    if (this.nodeType === 1) $(this).html( $(this).html().replace(/>>([0-9]+)/g, "<a href=\"#$1\">>>$1</a>") );
  });

});
