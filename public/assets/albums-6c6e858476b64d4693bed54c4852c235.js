function addGalleryImage(e){$(".seek_img_spinner").show();{var a=$(e).val();$(e)}""!=a&&$("#new_gallery").ajaxSubmit(function(e){e.success?($(".seek_img_spinner").hide(),$(".seekImgName").html(e.name),$(".imageUplaodBoxContainer").prepend(""+e.html),$(".uploadSeekImgBtnBox").hide(),$(".imageUplaodBox").show(),$(".seekImgHolder").css("background","#FFFFFF")):(brandiktivAlert(""+e.msg),$(".seek_img_spinner").hide())})}function destroyAlbumImage(e){var a=$(e).parent().attr("data-id");$.ajax({url:"/galleries/"+a,type:"DELETE",headers:{"X-Transaction":"POST Example","X-CSRF-Token":$('meta[name="csrf-token"]').attr("content")},success:function(){$(e).parent().remove()}})}