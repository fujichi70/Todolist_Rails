class DonesController < ApplicationController
	def index
		@done = Done.all
	end

end
