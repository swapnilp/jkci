
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

function classFilterByBatch(event, self){
    event.preventDefault();
    batch_id = $("#filter_batch_class").val();
    $.get("/jkci_class/filter_class/batch?&btch_id="+batch_id, function(data){
	$(".jkciClassTable tbody").html(data['html']);
    });
}
