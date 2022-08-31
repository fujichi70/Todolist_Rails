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
				time = 
				session[:done]       = params[:done]
				session[:date]       = params[:date]
				session[:start_time] = Time.current.strftime('%H:%M:%S')
				session[:created_at] = Time.current.strftime('%Y-%m-%d')

				params[:start_btn] = ''
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
					done.end_time   = Time.current.strftime('%H:%M:%S')
					done.created_at = session[:created_at]
					done.save
					
					params[:end_btn] = ''
					session.clear
					redirect_to '/dones', notice: 'やったことを追加しました'
				else
					redirect_to '/dones' , alert: '最初からやり直してください'
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
		redirect_to '/dones', notice: 'やったことを削除しました。'
	end
	
	def csv
		@user = User.select(:email)
		@done = Done.where(:email == @user)

		respond_to do |format|
			format.html
			format.csv do
				csv_output(@done)
			end
		end
	end

	private
		# csv出力
		def csv_output(dones)
			require 'csv'

			user  = current_user.email

			#ファイル名を指定 ここはお好みで
			filename = "done_" + Time.current.strftime("%Y%m%d")
			bom = "\uFEFF"

			csv1 = CSV.generate(bom) do |csv|
				#カラム名を1行目として入れる
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
			#ファイル書き込み
			File.open("./#{filename}.csv", "w", encoding: "UTF-8") do |file|
			file.write(csv1)
			end
			#send_fileを使ってCSVファイル作成後に自動でダウンロードされるようにする
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
