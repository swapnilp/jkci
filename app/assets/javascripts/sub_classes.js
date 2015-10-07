function modalOpen(title, bodyUrl, jkci_class_id, sub_class_id){
  $('#myModal').modal({
    keyboard: false
  })
  $("#myModal.modal .modal-header").html("<button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button><h4 class='modal-title' >"+title+"</h4>");
  $("#myModal.modal .modal-footer").append("<button type='button' class='btn btn-primary modelAction' onclick='saveSubClassStuent(this);' data-jkci-id="+jkci_class_id+" data-sub-class-id="+sub_class_id+">Save changes</button>");
  $.get(""+bodyUrl, function(data){
    $("#myModal.modal .modal-body").html('');
    $("#myModal.modal .modal-body").append("<div>");
    $.each(data.students, function(index, student){
      $("#myModal.modal .modal-body").append("<input type='checkbox' name="+student['id']+" value="+student['id']+">"+ student['first_name']+ " "+ student['last_name']+ "<br />");
    });
    $("#myModal.modal .modal-body").append("</div>");
  }, function(){}, "JSON")
}


function saveSubClassStuent(self) {
  studentsList = $('#myModal.modal .modal-body input:checked').map(function(){
    return $(this).val();
  }).toArray();
  jkci_class_id = $(self).data('jkci-id');
  sub_class_id = $(self).data('sub-class-id');
  $.get("/jkci_classes/" + jkci_class_id + "/sub_class/" + sub_class_id+ "/add_students?&students="+ studentsList,
    function(data){
      if(data.success){
	location.reload();
      }else{
	alert('something went wrong');
      }
      
    }, function(){}, "JSON");
}
