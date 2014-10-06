

function getClassStudents(event, self){
    event.preventDefault();
    id = $(self).data("id");
    $.get("/daily_teach/"+id+"/students", function(data){
	$(".classCatlog").html(""+data.html);
    }, function(){}, "JSON")
}

function saveDailyCatlog(event, self){
    event.preventDefault();
    if (window.confirm("Are you sure?")) {
	 selectedStudents = [];
	$(".classCatlog input[type=checkbox]:checked").each(function(){
	    selectedStudents.push($(this).attr("id"));
	})
	$(".dtpStudents").val(""+ selectedStudents);
	$(".dtpDate").val("" + $(".dailyTeachDate").text().trim());
	$(".fillCatlogForm").submit();
    }
}

function dailyTeachFilter(event, self){
    class_id = $("#filter_teach_class").val();
    teacher= $("#filter_teach_teacher").val();
    $.get("/daily_teach/filter_daily_teach/daily_teach?&class_id="+class_id+"&teacher="+teacher, function(data){
	$(".dailyTeachTable tbody").html(data['html']);
    });
}
