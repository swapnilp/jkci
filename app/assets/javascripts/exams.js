

function examFilterByClass(event, self){
    class_id = $(".filter_exam_class").val();
    type= $("#filter_exam_type").val();
    $.get("/exams/filter_exam/exam?&class_id="+class_id+"&type="+type, function(data){
	$(".examsTable tbody").html(data['html']);
    });
}


