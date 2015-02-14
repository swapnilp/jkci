
function addBatchResult(event, self){
  event.preventDefault();
  url = $(self).attr('href');
  $.get(""+url, function(data){
    $(".newBatchResult").html(''+ data['html']);
    $(".newBatchResult").removeClass('hide');
  }, function(){}, "JSON" );
}

function  cancelAddStudent(event){
  event.preventDefault();
  $(".newBatchResult").addClass('hide');
  $(".newBatchResult").html('');
}

function submitResultForm(event, self){
  event.preventDefault();
  var postData = $(self).serializeArray();
  var formURL = $(self).attr("action");
  $.ajax(
    {
      url : formURL,
      type: "POST",
      data : postData,
      success:function(data, textStatus, jqXHR) 
      {
	$(".newBatchResult").addClass('hide');
	$(".newBatchResult").html('');
	if(data['is_new'] == true ){
	  $('.batchResultStudent').append(""+ data['html']);
	}else{
	  $(''+data['cssHolder']).replaceWith(''+ data['html']);
	}
      },
      error: function(jqXHR, textStatus, errorThrown) 
      {
      }
    });
}

function removeBatchResult(event, self){
  var conf = confirm("Are you sure !!! ");
  if(conf == true){
    id = $(self).parent('div').data('id');
    $.ajax({
      url: '/results/'+ id,
      type: 'DELETE',
      success: function(data) {
	if(data['success'] == true){
	  $(self).parent('div').remove();
	}
      }
    });

  }
}

function editBatchResult(event, self){
  event.preventDefault();
  url = $(self).data('href');
  $.get(""+url, function(data){
    $(".newBatchResult").html(''+ data['html']);
    $(".newBatchResult").removeClass('hide');
  }, function(){}, "JSON" );
}

function addImageEvent(event){
  event.preventDefault();
  $('#image_attachment_field').click();
}

function addCoverImageEvent(event){
  event.preventDefault();
  $('#image_cover_attachment_field').click();
}


function addResultImage(self){
  $a = self;
  $('.seek_img_spinner').show();
  var file_path = $(self).val()
  var thsEle = $(self);
  if(file_path != ''){
    $(self).parent('form').ajaxSubmit(function(data){
      if(data.success){
        $("#result_student_img").val(''+ data['url']);
        
      }else{
        brandiktivAlert(""+ data.msg);
        $('.seek_img_spinner').hide();
      }
    });
  }
}

function addCoverResultImage(self){
  $a = self;
  $('.seek_img_spinner').show();
  var file_path = $(self).val()
  var thsEle = $(self);
  if(file_path != ''){
    $(self).parent('form').ajaxSubmit(function(data){
      if(data.success){
	$("#result_student_img").val(''+ data['url']);
      }else{
        brandiktivAlert(""+ data.msg);
        $('.seek_img_spinner').hide();
      }
    });
  }
  
}
