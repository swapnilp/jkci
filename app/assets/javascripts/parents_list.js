
function downloadParentsList(event, self) {
  event.preventDefault();
  vals = $("#jkci_class_ids").val()
  $.get("/parents_list/get_list?&jkci_class_ids=" + vals, function(data){
    console.log(data);
  }, function(){}, "JSON")
}

function getParentsList(event, self) {
  event.preventDefault();
  $(".parentsListTable tbody").html('');
  vals = $("#jkci_class_ids").val()
  $.get("/parents_list/get_parent_list?&jkci_class_ids="+ vals, function(data){
    $.each(data.students, function(index, student){
      $(".parentsListTable tbody").append("<tr><td>" + index + "</td><td>"+student.parent_name+"</td><td>"+student.p_mobile+"</td><td></td><td></td></tr>");
    })
  }, function(){}, "JSON")
}
