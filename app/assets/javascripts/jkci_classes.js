
var selectedStudents = []

function assignClassStudents(event, self){
    event.preventDefault();
    selectedStudents = [];
    id = $(self).data("id");
    $(".assignedStudents input[type=checkbox]:checked").each(function(){
	selectedStudents.push($(this).attr("id"));
    })
    $.post("/class/"+id +"/manage_students.json", {students_ids: selectedStudents}, function(data){
	window.location = "/jkci_classes/"+ data.id;
    })	
}
