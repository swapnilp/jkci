function meetingSmsSend(event, self){
  event.preventDefault();
  if(confirm('Are you Sure?')){
    $.get($(self).attr('href'), function(data){
      if(data.success){
	$(self).remove();
	alert('Message will be send');
      }
    }, function(){}, 'JSON');
  }
}
