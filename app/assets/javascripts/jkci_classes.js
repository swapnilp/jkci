
var selectedStudents = [];
var selectedPoints = [];

function assignClassStudents(event, self){
    event.preventDefault();
    selectedStudents = [];
    if (window.confirm("Are you sure?")) {
	id = $(self).data("id");
	$(".assignedStudents input[type=checkbox]:checked").each(function(){
	    selectedStudents.push($(this).attr("id"));
	})
	    $.post("/class/"+id +"/manage_students.json", {students_ids: selectedStudents}, function(data){
		window.location = "/jkci_classes/"+ data.id;
	    })	
    }
}

function createClassExam(event, self){
    event.preventDefault();
    selectedPoints = [];
    if (window.confirm("Are you sure?")) {
	id = $(self).data("id");
	$(".dailyTeach input[type=checkbox]:checked").each(function(){
	    selectedPoints.push($(this).attr("id"));
	})
	    window.location = "/exams/new?&jkci_class_id="+ id +"&dtp="+ selectedPoints;
    }
}
