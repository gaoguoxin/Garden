class WechartJob < ActiveJob::Base
	queue_as :garden
	def perform(type,openid)
		case type
		when 'subscribe'
			User.get_wechart_info(openid)
		end
	end	
end