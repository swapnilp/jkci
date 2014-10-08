

function examFilterByClass(event, self){
    class_id = $(".filter_exam_class").val();
    type= $("#filter_exam_type").val();
    status = $("#filter_exam_status").val();
    $.get("/exams/filter_exam/exam?&class_id="+class_id+"&type="+type+"&status="+status, function(data){
	$(".examsTable tbody").html(data['html']);
    });
}


