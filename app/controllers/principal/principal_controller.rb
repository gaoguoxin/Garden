class Principal::PrincipalController < ApplicationController
	before_filter :require_login
	before_filter :require_principal

	def require_principal
		redirect_to root_url unless @current_user.is_principal?
	end
end
