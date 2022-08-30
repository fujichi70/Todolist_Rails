class DonesController < ApplicationController
	def index
		@done = Done.all
	end
	
	def store
		done = Done.new
		
		done.email       = current_user.email
		done.done       = params[:done]
		done.date      = params[:date]
		done.start_time      = params[:start_time]
		done.end_time      = params[:end_time]
		done.created_at = Time.now.strftime('%Y-%m-%d')
		done.save

		redirect_to '/', notice: 'やったことを追加しました'
	end

end
