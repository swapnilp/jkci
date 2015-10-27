function openMobileCodeModal(title, url){
  $('#myModal').modal({
    keyboard: false
  })
  $("#myModal.modal .modal-header").html("<button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button><h4 class='modal-title' >"+title+"</h4>");
  $("#myModal.modal .modal-footer").append("<button type='button' class='btn btn-primary modelAction' onclick='generateMobileCode(this);' data-url="+url+">Generate Code</button>");

  $("#myModal.modal .modal-body").html('');
  $("#myModal.modal .modal-body").append("<div>");
  $("#myModal.modal .modal-body").append("<strong>Mobile Number</strong>  <input type='text' name='mobile' class='mobileCode' onkeypress='return isNumber(event)'>");
  $("#myModal.modal .modal-body").append("</div>");
}


function generateMobileCode(self) {
  studentsList = $('#myModal.modal .modal-body input:checked').map(function(){
    return $(this).val();
  }).toArray();
  url = $(self).data('url');
  mobile = $('.mobileCode').val();
  if(mobile.length == 10){
  $.get("" + url + "?&mobile="+ mobile,
    function(data){
      $('#myModal').modal('hide');
    }, function(){}, "JSON");
  }else{
    $('.mobileCode').addClass('redBorder');
  }
}

function isNumber(evt) {
  evt = (evt) ? evt : window.event;
  var charCode = (evt.which) ? evt.which : evt.keyCode;
  if (charCode > 31 && (charCode < 48 || charCode > 57)) {
    return false;
  }
  return true;
}


function openOrganisationCoursesModal(event, title, self, url){
  event.preventDefault();
  $('#myModal').modal({
    keyboard: false
  })
  $("#myModal.modal .modal-header").html("<button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button><h4 class='modal-title' >"+title+"</h4>");
  $("#myModal.modal .modal-footer").append("<button type='button' class='btn btn-primary modelAction' onclick='saveOrganisationCourses(this);' data-url="+url+">Add Courses</button>");

  $("#myModal.modal .modal-body").html('');
  $("#myModal.modal .modal-body").append("<div>");
  $.get($(self).attr('href'), function(data){
    $("#myModal.modal .modal-body").append("<div>");
    $.each(data.standards, function(index, standard){
      $("#myModal.modal .modal-body").append("<input type='checkbox' name="+standard['id']+" value="+standard['id']+">"+ standard['name']+ "<br />");
    });
    $("#myModal.modal .modal-body").append("</div>");
  }, function(){}, 'JSON');
  $("#myModal.modal .modal-body").append("</div>");
}

function saveOrganisationCourses(self) {
  coursesList = $('#myModal.modal .modal-body input:checked').map(function(){
    return $(this).val();
  }).toArray();
  url = $(self).data('url');
  $.post(""+ url +"?&courses="+ coursesList,
    function(data){
      if(data.success){
	location.reload();
      }else{
	alert('something went wrong');
      }
    }, function(){alert('something went wrong');}, "JSON");
}
