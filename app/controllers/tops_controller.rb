class TopsController < ApplicationController
	before_action :move_to_signed_in, except: [:index]

	def index
		user       = current_user.email
		@tasks     = Task.where(email: user, complete_flag: nil)
		@completes = Task.where(email: user, complete_flag: 1)
	end

	def store
		task = Task.new
		
		if params[:task].present?
			task.email         = current_user.email
			task.task          = params[:task]
			task.date          = params[:date]
			task.time          = params[:time]
			task.complete_flag = nil
			task.created_at    = Time.current.strftime('%Y-%m-%d')
			task.save

			redirect_to '/', notice: 'タスクを追加しました。'
		else
			redirect_to '/', alert: 'やることを入れてください。'
		end
	end

	def show
		id    = params[:id]
		@task = Task.find(id)
	end

	def complete
		id   = params[:id]
		task = Task.find(id)

		task.complete_flag = 1
		task.updated_at    = Time.current.strftime('%Y-%m-%d')
		task.save

		redirect_to '/', notice: 'タスクを完了しました。'
	end

	def update
		id   = params[:id]
		task = Task.find(id)

		if params[:task].present?
			task.task       = params[:task]
			task.date       = params[:date]
			task.time       = params[:time]
			task.updated_at = Time.current.strftime('%Y-%m-%d')
			task.save

			redirect_to '/', notice: 'タスクを更新しました。'
			return false
		else
			redirect_to request.referer, alert: 'やることを入れてください。'
			return false
		end
	end

	def destroy
		id   = params[:id]
		task = Task.find(id)
		task.destroy
		redirect_to '/', alert: 'タスクを削除しました。'
	end

	private
		# ログインしてない場合ログインページに遷移
		def move_to_signed_in
			unless user_signed_in?
			redirect_to  '/users/sign_in'
		end
	end

end
