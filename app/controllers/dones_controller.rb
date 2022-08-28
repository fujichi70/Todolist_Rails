class DonesController < ApplicationController
	def index
		@done = Done.all
	end
	
	def store
		id      = params[:id]
		@done = Done.find(id)
	end

end
