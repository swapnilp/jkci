function searchStudentByFilter(event){
  e = event || window.event;
  if (e.keyCode == 13)
  {
    batch_id = $(".filter_student_batch").val();
    filter = $(".filter_student").val();
    genderFilter = $(".filter_student_gender").val();
    
    //status = $("#filter_exam_status").val();
    $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter+"&gender="+ genderFilter, function(data){
      $(".studentsTable tbody").html(data['html']);
      $(".paginationDiv").html(data['pagination_html']);
    });
  }
}

function studentFilterByBatch(event, self){

  batch_id = $(".filter_student_batch").val();
  filter = $(".filter_student").val();
  genderFilter = $(".filter_student_gender").val();

  //status = $("#filter_exam_status").val();
  $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter+"&gender="+ genderFilter, function(data){
    $(".studentsTable tbody").html(data['html']);
    $(".paginationDiv").html(data['pagination_html']);
  });
}

function getUsersForStudent(event, self){
  event.preventDefault();
  $.get($(self).attr('href'), function(data){
    $('.userLoginDiv').html( data['html']);
  }, function(){}, 'JSON');
}

function studentFilterByGender(event, self){
  event.preventDefault();
  
  batch_id = $(".filter_student_batch").val();
  filter = $(".filter_student").val();
  genderFilter = $(".filter_student_gender").val();

  //status = $("#filter_exam_status").val();
  $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter+"&gender="+ genderFilter, function(data){
    $(".studentsTable tbody").html(data['html']);
    $(".paginationDiv").html(data['pagination_html']);
  });
  
}

function enableStudentSms(self, event){
  event.preventDefault();

  $.get(''+ $(self).attr('href'), function(data){
    if(data.success){
      $(self).remove();
    }
  }, function(){}, "JSON");
}
