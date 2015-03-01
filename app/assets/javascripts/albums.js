


function addGalleryImage(self){
  $('.seek_img_spinner').show();
  var file_path = $(self).val()
  var thsEle = $(self);
  if(file_path != ''){
    $(self).parent().find('.loadingImg').removeClass('hide');
    $('#new_gallery').ajaxSubmit(function(data){
      if(data.success){
        $(self).parent().find('.loadingImg').hide();
        $(".seekImgName").html(data['name']);
        //$("#seek_image_url").val($("#seek_image_url").val() + data['image_path'] +",");
        $(".imageUplaodBoxContainer").prepend(""+ data['html']);
        $(".uploadSeekImgBtnBox").hide();
        $(".imageUplaodBox").show();
        $(".seekImgHolder").css("background", "#FFFFFF");
	$(".loadingImg").addClass('hide');
      }else{
        brandiktivAlert(""+ data.msg);
	$(self).parent().find('.loadingImg').addClass('hide');
      }
    });
  }
  
}

function destroyAlbumImage(self) {
    var id = $(self).parent().attr('data-id');
    $.ajax({
	url: '/galleries/'+ id,
	type: 'DELETE',
	headers: {
	    'X-Transaction': 'POST Example',
	    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
	},
	success: function(result) {
            $(self).parent().remove();
	}
    });
}

