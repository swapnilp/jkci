function searchStudentByFilter(event){
  e = event || window.event;
  if (e.keyCode == 13)
  {
    batch_id = $(".filter_student_batch").val();
    filter = $(".filter_student").val();
    
    status = $("#filter_exam_status").val();
    $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter, function(data){
      $(".studentsTable tbody").html(data['html']);
      $(".paginationDiv").html(data['pagination_html']);
    });
  }
}

function studentFilterByBatch(event, self){

  batch_id = $(".filter_student_batch").val();
  filter = $(".filter_student").val();
  status = $("#filter_exam_status").val();
  $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter, function(data){
    $(".studentsTable tbody").html(data['html']);
    $(".paginationDiv").html(data['pagination_html']);
  });
}
