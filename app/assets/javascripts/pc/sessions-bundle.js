$(function(){
	$('.login-panel input').focus(function(){
		$('#warning_div').css("visibility","hidden");
	});

	function submitForm(){
		var mobile = $.trim($('#mobile').val());
		var pwd    = $.trim($('#pwd').val());
		if(mobile.length > 0 && pwd.length > 0){
			$.post('/sessions',{mobile:mobile,password:pwd},function(retval){
				if(retval.success){
					window.location.href = '/';
				}else{
					$('#warning_div').css("visibility","visible");
				}
			})
		}		
	}

	$('#login-btn').click(function(e){
		e.preventDefault();
		submitForm();
	});
	$('#pwd').keypress(function(e){
	   if(e.which == 13){
			submitForm();
	   }
   });
	
})