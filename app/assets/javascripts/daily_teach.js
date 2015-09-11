

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
    });
    $(".dtpStudents").val(""+ selectedStudents);
    $(".dtpDate").val("" + $(".dailyTeachDate").text().trim());
    $(".fillCatlogForm").submit();
    $(".editDailyCatlog").removeClass('hide');
    $(".saveDailyCatlog").addClass('hide');
    $(".dailyTeachStudents input[type=checkbox]").attr('disabled', 'disabled');
  }
}

function dailyTeachFilter(event, self){
  event.preventDefault();
  class_id = $("#filter_teach_class").val();
  teacher= $("#filter_teach_teacher").val();
  $.get("/daily_teach/filter_daily_teach/daily_teach?&class_id="+class_id+"&teacher="+teacher, function(data){
    $(".dailyTeachTable tbody").html(data['html']);
    $(".paginationDiv").html(data['pagination_html']);
  });
}

function editDailyCatlog(event, self){
  event.preventDefault();
  $(self).addClass('hide');
  $(".saveDailyCatlog").removeClass('hide');
  $(".cancelSaveClassCatlog").removeClass("hide");
  $(".dailyTeachStudents input[type=checkbox]").attr('disabled', false);
  $(".dailyTeachStudents").removeClass('hide');
}


function cancelClassCatlog(event, self){
  event.preventDefault();
  $(".saveDailyCatlog").addClass('hide');
  $(".cancelSaveClassCatlog").addClass("hide");
  $(".editDailyCatlog").removeClass('hide');
  $(".dailyTeachStudents input[type=checkbox]").attr('disabled', 'disabled');
  $(".dailyTeachStudents").addClass('hide');
}

function recoverDailyTeach(event, self){
  event.preventDefault();
  $.get($(self).attr('href')+".json", function(){
    $(self).parent().remove();
  })
}

function dailyTeachingChapterSelect(event, self){
  //event.preventDefault();
  $(".dailyTeach tbody").html('');
  selectedChapters = "";
  $(".dailyTeachChapters input[type=checkbox]:checked").each(function(){
    selectedChapters = selectedChapters + $(this).attr("data-id") + ",";
  });
  classId = $(self).parent().attr('data-class-id');
  $('#k-tab-daily_teach .loadingImg').removeClass('hide');
  
  $.get("/jkci_class/" + classId + "/daily_teaches?&chapters="+ selectedChapters, function(data){
    $(".dailyTeach tbody").html(''+ data.html);
    $('.dailyTeachChapters').parent().find('.pagination').html(''+ data.pagination_html);
    $('#k-tab-daily_teach .loadingImg').addClass('hide');
  }, function(){}, "JSON")
}

function selectChaptersPoint(event, self){
  chapter_id  = $(self).prop('value');
  $.get("/chapters/" + chapter_id + "/chapters_points", function(data){
    $('#daily_teaching_point_chapters_point_id').empty();
    $.each(data.points, function(value, key){
      $('#daily_teaching_point_chapters_point_id')
	.append($("<option></option>")
	   .attr("value", key.id)
	   .text(key.name));
    })
  }, function(){
  }, 'JSON'); 
}

function selectClassChapters(event, self){
  jkci_class_id  = $(self).prop('value');
  $.get("/jkci_class/" + jkci_class_id + "/chapters", function(data){
    $('#daily_teaching_point_chapter_id').empty();
    $.each(data.chapters, function(value, key){
      $('#daily_teaching_point_chapter_id')
    	.append($("<option></option>")
    	   .attr("value", key.id)
    	   .text(key.name));
    })
    $('#daily_teaching_point_chapters_point_id').empty();
    $.each(data.points, function(value, key){
      $('#daily_teaching_point_chapters_point_id')
    	.append($("<option></option>")
    	   .attr("value", key.id)
    	   .text(key.name));
    })  
  }, function(){
  }, 'JSON'); 
}
