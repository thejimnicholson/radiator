$.ajaxSetup ({  
     cache: false  
  });

$(document).ready(function() { 
	update_views(); 
	$('.button').button();
	$('#edit').hide();
	$('#configure').click(function() {
		$('#edit').dialog();
		$('#edit').show();
		$.get('/views_list',function(data){
			$('#views').html(data);
			$('#views').width($('#edit form').width() - $('#edit label').width() - 15);
		},'html');
		
	})
	});



function update_views() {
	$.get("/views",function(data) {
            $("#main").html(data);
            window.setTimeout(update_views, 60000);
          },
          'html');
}

function show_edit_dialog() {
	$('#edit').dialog();
	$('#edit').show();	
}