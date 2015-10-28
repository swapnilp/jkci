
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
      window.location = "/jkci_classes/"+id+"/exams/new?&dtp="+ selectedPoints;
  }
}

function classFilterByBatch(event, self){
  event.preventDefault();
  batch_id = $("#filter_batch_class").val();
  $.get("/jkci_class/filter_class/batch?&batch_id="+batch_id , function(data){
    $(".jkciClassTable tbody").html(data['html']);
    $(".paginationDiv").html(data['pagination_html']);
  });
}


function downloadSubClassCatlog(event, self){
  event.preventDefault();
  selectedSubClass = [];
  $(".subClass input[type=checkbox]:checked").each(function(){
    selectedSubClass.push($(this).attr("id"));
  });
  window.open(''+ $(self).attr("href")+'?&subclass='+selectedSubClass);
}
