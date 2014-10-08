
function followStudent(event, self){
    event.preventDefault();
    if (window.confirm("Are you sure?")) {
	$.get($(self).data('href')+".json", function(){
	    $(self).parent().parent().remove();	
	})
    }
    
    
}
