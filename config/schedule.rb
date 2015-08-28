case @environment 
when 'production'
	every :hour do
	  runner "Wechart.batch_refresh_tasks"	
	end
end
