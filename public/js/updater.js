$.ajaxSetup ({  
     cache: false  
  });

$(document).ready(function() { update_views(); });



function update_views() {
	$.get("/views",function(data) {
            $("#main").html(data);
            window.setTimeout(update_views, 60000);
          },
          'html');
}