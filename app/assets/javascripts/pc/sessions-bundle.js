$(function(){
	$('.login-panel input').focus(function(){
		$(this).prev('label').find('.text-danger').hide();
	});
	$('.login-btn').click(function(e){
		e.preventDefault();
		var mobile = $.trim($('#mobile').val());
		var pwd    = $.trim($('#pwd').val());
		if(mobile.length > 0 && pwd.length > 0){
			$.post('/sessions',{mobile:mobile,password:pwd},function(retval){
				if(retval.success){
					window.location.href = '/';
				}else{
					if(retval.data == 'error_01'){
						$('.text-danger:first').show();
					}else{
						$('.text-danger:last').show();
					}
				}
			})
		}
	});
	
})