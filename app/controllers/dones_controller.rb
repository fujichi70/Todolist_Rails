class DonesController < ApplicationController
	def index
		@done = Done.all
	end
	
	def store
		
		if params[:start_btn].present?
			time = 
			session[:done]       = params[:done]
			session[:date]       = params[:date]
			session[:start_time] = Time.now.strftime('%H:%M:%S')
			session[:created_at] = Time.now.strftime('%Y-%m-%d')
			redirect_to '/dones'
		else
			if session[:start_time].present?
				done = Done.new
				
				if session[:done].present?
					done.done = session[:done]
				elsif params[:done].present?
					done.done = params[:done]
				else
					redirect_to '/dones' , alert: '最初からやり直してください'
				end
				
				if session[:date].present?
					done.date = session[:date]
				elsif params[:date].present?
					done.date = params[:date]
				else
					redirect_to '/dones' , alert: '最初からやり直してください'
				end
				
				done.email      = current_user.email
				done.start_time = session[:start_time]
				done.end_time   = Time.now.strftime('%H:%M:%S')
				done.created_at = session[:created_at]
				done.save
				
				session = ''
				redirect_to '/dones', notice: 'やったことを追加しました'
			else
				redirect_to '/dones' , alert: '最初からやり直してください'
			end	
		end	
		
	end

end
