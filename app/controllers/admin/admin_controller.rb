class Admin::AdminController < ApplicationController
	before_filter :require_login
	before_filter :require_admin

	def require_admin
		redirect_to root_url unless @current_user.is_admin?
	end
end
