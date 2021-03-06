function searchStudentByFilter(event){
  e = event || window.event;
  if (e.keyCode == 13)
  {
    batch_id = $(".filter_student_batch").val();
    filter = $(".filter_student").val();
    genderFilter = $(".filter_student_gender").val();
    standard = $(".filter_student_standard").val();
    
    //status = $("#filter_exam_status").val();
    $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter+"&gender="+ genderFilter+"&standard="+standard, function(data){
      $(".studentsTable tbody").html(data['html']);
      $(".paginationDiv").html(data['pagination_html']);
    });
  }
}

function studentFilter(event, self){

  batch_id = $(".filter_student_batch").val();
  filter = $(".filter_student").val();
  genderFilter = $(".filter_student_gender").val();
  standard = $(".filter_student_standard").val();

  //status = $("#filter_exam_status").val();
  $.get("/students/filter_student/student?&batch_id="+batch_id+"&filter="+filter+"&gender="+ genderFilter+"&standard="+standard, function(data){
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

function enableStudentSms(self, event){
  event.preventDefault();

  $.get(''+ $(self).attr('href'), function(data){
    if(data.success){
      $(self).remove();
    }
  }, function(){}, "JSON");
}

function selectStandardOSubjects(event, self) {
  event.preventDefault();
  var id = $(self).val();
  $("#o_subjects").empty();
  $.get("/standards/"+id+"/optional_subjects", function(data){
    $.each(data.subjects, function(value, key){
      $('#o_subjects')
	.append($("<option></option>")
	   .attr("value", key.id)
	   .text(key.name));
    });
  }, function(){}, "JSON");
  
  
}
