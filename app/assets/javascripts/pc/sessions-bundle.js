$(function(){
	$('.login-panel input').focus(function(){
		$('#warning_div').css("display","none");
	});
	$('#login-btn').click(function(e){
		e.preventDefault();
		var mobile = $.trim($('#mobile').val());
		var pwd    = $.trim($('#pwd').val());
		if(mobile.length > 0 && pwd.length > 0){
			$.post('/sessions',{mobile:mobile,password:pwd},function(retval){
				if(retval.success){
					window.location.href = '/';
				}else{
					if(retval.data == 'error_01'){
						$('#warning_div').css("display","block");
						//$('.text-danger:first').show();
					}else{
						$('#warning_div').css("display","block");
						//$('.text-danger:last').show();
					}
				}
			})
		}
	});
	$('#pwd').keypress(function(e){
	   var curKey = e.which;
	   if(curKey == 13)
	   {
	       	var mobile = $.trim($('#mobile').val());
			var pwd    = $.trim($('#pwd').val());
			if(mobile.length > 0 && pwd.length > 0){
				$.post('/sessions',{mobile:mobile,password:pwd},function(retval){
					if(retval.success){
						window.location.href = '/';
					}else{
						if(retval.data == 'error_01'){
							$('#warning_div').css("display","block");
							//$('.text-danger:first').show();
						}else{
							$('#warning_div').css("display","block");
							//$('.text-danger:last').show();
						}
					}
				})
			}
	   }
   });
	
})