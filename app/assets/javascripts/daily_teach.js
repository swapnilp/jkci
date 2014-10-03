

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
