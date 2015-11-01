
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


function checkUinqRollnumber(event, self){
  event.preventDefault();
  var values = [];
  var isSubmit = true;
  $('input[class^=uniq]').each(function() {
    if ( this.value!= "" && $.inArray(this.value, values) >= 0 ) {
      isSubmit = false;
      return false; // <-- stops the loop
    } else {
      if(this.value!= ""){
	values.push( this.value );
      }
    }
  });
  if(isSubmit){
    $("#classRollNumberForm").submit();
  }else {
    alert("Roll number must be uniq");
  }
}

function classSmsToggle(self) {
  url = $(self).data('url');
  value = $(self).prop('checked');
  
  $.get(url+"?&value="+value, function(data) {
  }, function(){}, "JSON");
}

function removeClassStudent(event, self) {
  event.preventDefault();
  if(confirm("Are you sure?")) {
    $.ajax({
      url: ''+$(self).attr('href'),
      type: 'DELETE',
      dataType: "JSON",
      success: function(result) {
	$(self).parent().parent().remove();
      }
    });
  }
  
}
