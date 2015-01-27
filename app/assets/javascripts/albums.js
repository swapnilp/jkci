


function addGalleryImage(self){
    $('.seek_img_spinner').show();
    var file_path = $(self).val()
    var thsEle = $(self);
    if(file_path != ''){
      $('#new_gallery').ajaxSubmit(function(data){
       if(data.success){
         $('.seek_img_spinner').hide();
         $(".seekImgName").html(data['name']);
           //$("#seek_image_url").val($("#seek_image_url").val() + data['image_path'] +",");
         $(".imageUplaodBoxContainer").prepend(""+ data['html']);
         $(".uploadSeekImgBtnBox").hide();
         $(".imageUplaodBox").show();
         $(".seekImgHolder").css("background", "#FFFFFF");
         
       }else{
         brandiktivAlert(""+ data.msg);
         $('.seek_img_spinner').hide();
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

