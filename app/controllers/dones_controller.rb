class DonesController < ApplicationController
	before_action :move_to_signed_in
	
	def index
		user = current_user.email
		time = Time.current.strftime("%Y-%m-%d")
		@done = Done.where(email: user, date: time )
	end
	
	def store
		
		if params[:start_btn].present? || params[:end_btn].present?
			if params[:start_btn].present?
				if params[:date].present?
					session[:done]       = params[:done]
					session[:date]       = params[:date]
					session[:start_time] = Time.current.strftime('%H:%M')
					session[:created_at] = Time.current.strftime('%Y-%m-%d')

					redirect_to '/dones'
				else
					session.clear
					redirect_to '/dones' , alert: '日付は必ず入力してください'
				end
			else
				if session[:start_time].present?
					done = Done.new

					if session[:done].present?
						done.done = session[:done]
					elsif !params[:done].empty?
						done.done = params[:done]
					else
						session.clear
						redirect_to '/dones' , alert: '最初からやり直してください'
						return false
					end
					
					if session[:date].present?
						done.date = session[:date]
					elsif params[:date].present?
						done.date = params[:date]
					else
						session.clear
						redirect_to '/dones' , alert: '最初からやり直してください'
						return false
					end
					
					done.email      = current_user.email
					done.start_time = session[:start_time]
					done.end_time   = Time.current.strftime('%H:%M')
					done.created_at = session[:created_at]
					done.save
					
					params[:end_btn] = ''
					session.clear
					redirect_to '/dones', notice: 'やったことを追加しました'
				else
					session.clear
					redirect_to '/dones' , alert: '最初からやり直してください'
					return false
				end	
			end
			
		elsif params[:add_btn].present?
			done = Done.new
		
			done.email       = current_user.email
			done.done       = params[:done]
			done.date      = params[:date]
			done.start_time      = params[:start_time]
			done.end_time      = params[:end_time]
			done.created_at = Time.current.strftime('%Y-%m-%d')
			done.save
			
			params[:add_btn] = ''
			redirect_to '/dones', notice: 'やったことを追加しました'
		else
			redirect_to '/dones', notice: '最初からやり直してください'
		end
		
	end

	def update
		id   = params[:id]
		done = Done.find(id)

		done.done      = params[:done]
		done.date      = params[:date]
		done.time      = params[:time]
		done.updated_at = Time.current.strftime('%Y-%m-%d')
		done.save

		redirect_to '/dones', notice: 'やったことを更新しました。'
	end
	
	def destroy
		id = params[:id]
		done = Done.find(id)
		done.destroy
		redirect_to '/dones', alert: 'やったことを削除しました。'
	end
	
	def csv
		@user = User.select(:email)
		@done = Done.where(:email == @user)
		
		# csv出力
		respond_to do |format|
			format.html
			format.csv do
				csv_output(@done)
			end
		end
	end

	private
		# 出力データ生成
		def csv_output(dones)
			require 'csv'

			user  = current_user.email

			filename = "done_" + Time.current.strftime("%Y%m%d")
			bom = "\uFEFF"

			csv1 = CSV.generate(bom) do |csv|
				column_names =["Subject", "Start date", "Start time", "End time", "Description"]

				csv << column_names
				dones.each do |d|
					column_values = [
						d.done,
						d.date,
						d.start_time,
						d.end_time,
						d.description,
					]
					csv << column_values
				end
			end
			create_csv(filename, csv1)
		end

		# csvファイル生成
		def create_csv(filename, csv1)
			File.open("./#{filename}.csv", "w", encoding: "UTF-8") do |file|
			file.write(csv1)
			end
			stat = File::stat("./#{filename}.csv")
			send_file("./#{filename}.csv", filename: "#{filename}.csv", length: stat.size)
		end

		# ログインしてない場合ログインページに遷移
		def move_to_signed_in
			unless user_signed_in?
			redirect_to  '/users/sign_in'
		end
	end


end
