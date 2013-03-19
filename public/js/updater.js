$.ajaxSetup ({  
     cache: false  
  });

$(document).ready(function() { 
	update_views(); 
	$('.button').button();
	$('#edit').hide();
	$('#configuration').click(function(e) {
		e.preventDefault();
		e.stopPropagation(); 
		$('#edit').dialog({modal: true});
		$('#edit').show();
		$.get('/configure',function(data){
			$('#edit').html(data);
			$('.button').button();
			$('input[type=checkbox]').prettyCheckboxes();
		},'html');
		
	})
});



function update_views() {
	$.get("/views",function(data) {
            $("#main").html(data);
			// $('.job p a').marquee();
            window.setTimeout(update_views, 60000);
          },
          'html');

}
