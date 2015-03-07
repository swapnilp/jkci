function parentDeskToggle(event, self){
  event.preventDefault();
  $('.parentDeskMenu li').removeClass('active');
  $(self).parent().addClass('active');
  $('.parentCatlogDiv').html('');
  $.get($(self).attr('href'), function(data){
    $('.parentCatlogDiv').html(''+ data['html']);
  }, function(){}, 'JSON')
}
