class Admin::SupervisorsController < Admin::AdminController
	def index
		@supervisors = User.admin_search(params)
	end
	
	def new 
	end

	def edit
	end

	def update
	end

	def destroy
	end
end
