class DonesController < ApplicationController
	before_action :move_to_signed_in
	
	def index
		@done = Done.where(:date == Time.now.strftime("%Y-%m-%d"))
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
				
				session.clear
				redirect_to '/dones', notice: 'やったことを追加しました'
			else
				redirect_to '/dones' , alert: '最初からやり直してください'
			end	
		end	
		
	end

	def update
		id   = params[:id]
		done = Done.find(id)

		done.done      = params[:done]
		done.date      = params[:date]
		done.time      = params[:time]
		done.updated_at = Time.now.strftime('%Y-%m-%d')
		done.save

		redirect_to '/', notice: 'やったことを更新しました。'
	end

	def destroy
		id = params[:id]
		done = Done.find(id)
		done.destroy
		redirect_to '/', notice: 'やったことを削除しました。'
	end

	private
		def move_to_signed_in
			unless user_signed_in?
			#サインインしていないユーザーはログインページが表示される
			redirect_to  '/users/sign_in'
		end
	end


end
