$(document).ready(function() {
  
  $('img.show_icon').click(function() {
    widget = $(this).parent().children('div.show_widget');
    widget.css({ display: 'block' });
    $(document).one('keydown', function(e) {
      if (e.which == 27) widget.css({ display: 'none' });
    });
  });
  
  $('img.edit_icon').click(function() {
    widget = $(this).parent().children('div.edit_widget');
    widget.css({ display: 'block' });
    $(document).one('keydown', function(e) {
      if (e.which == 27) widget.css({ display: 'none' });
    });
  });
  
  $('img.close_icon').click(function() {
    $(this).closest('div.overlay').css({ display: 'none' })
  });
  
});