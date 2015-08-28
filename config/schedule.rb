case @environment 
when 'production'
	every 50.minutes do
	  runner "Wechart.batch_refresh_tasks"	
	end
end
