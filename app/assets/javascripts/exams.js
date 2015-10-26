

function examFilterByClass(event, self){
  class_id = $(".filter_exam_class").val();
  type= $("#filter_exam_type").val();
  status = $("#filter_exam_status").val();
  $.get("/exams/filter_exam/exam?&class_id="+class_id+"&type="+type+"&status="+status, function(data){
    $(".examsTable tbody").html(data['html']);
    $('.dataCounts').html(''+data['count']);
    $(".paginationDiv").html(data['pagination_html']);
  });
}


function jsonPagination(event){
  $(".paginationDiv .pagination a").on('click', function(){
    alert("asdasd");
  })
}


function addExamDocumant(self){
  $a = self;
  $('.seek_img_spinner').show();
  var file_path = $(self).val()
  var thsEle = $(self);
  if(file_path != ''){
    $('.batchRLoadingImg').removeClass('hide');
    $(self).parent('form').ajaxSubmit(function(data){
      if(data.success){
	//$("#result_student_img").val(''+ data['url']);
	//$('.batchRLoadingImg').addClass('hide');
	$(".examDocument").append("<a href='"+data['url']+"' target='_blank'>"+data['name']+"</a>&nbsp;&nbsp;");
	alert('Paper Uploaded');
      }else{
        //brandiktivAlert(""+ data.msg);
	alert('Something went long');
	$('.batchRLoadingImg').addClass('hide');
      }
    });
  }
}

function download_exams_report(event, self) {
  event.preventDefault();
  class_id = $(".filter_exam_class").val();
  type= $("#filter_exam_type").val();
  status = $("#filter_exam_status").val();
  window.open(''+ $(self).attr('href')+".pdf?&class_id="+class_id+"&type="+type+"&status="+status);
}
