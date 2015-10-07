// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require jquery-migrate-1.2.1.min
//= require twitter/bootstrap
// require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require dropdown-menu/dropdown-menu
//= require jquery.easy-pie-chart
// require fancybox/jquery.fancybox.pack
// require fancybox/jquery.fancybox-media
//= require fancybox
//= require about_us 
//= require home
//= require albums
//= require daily_teach
//= require jkci_classes
//= require batch_results
//= require exams
//= require parent_desk
//= require students
//= require parents_meeting
//= require parents_list
//= require sub_classes
//= require ajax-submit
// require theme
// require_tree .

function adminPagination(event, self){
  event.preventDefault();
  href = $(self).attr('href');
  $.get(href, function(data){
    $(""+ data['css_holder']).html(data['html']);
    $(self).parents(".paginationDiv").html(data['pagination_html']);
  }, function(
  ){}, "JSON");
}


$('.fancybox').fancybox({ parent: "body"})

function clearModalData(){
  $("#myModal.modal .modal-header").html("");
  $("#myModal.modal .modal-body").html("<div class='col-sm-12 center'><img src='/assets/fancybox_loading.gif'></div>");
  $("#myModal.modal .modelAction").remove();
}
