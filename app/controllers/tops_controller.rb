class TopsController < ApplicationController
	before_action :move_to_signed_in, except: [:index]

	def index
		@tasks = Task.where(complete_flag: nil)
		@completes = Task.where(complete_flag: 1)
	end

	def store
		task = Task.new
		
		task.email       = current_user.email
		task.task       = params[:task]
		task.date      = params[:date]
		task.time      = params[:time]
		task.complete_flag = nil
		task.created_at = Time.now.strftime('%Y-%m-%d')
		task.save

		redirect_to '/', notice: 'タスクを追加しました'
	end

	def show
		id      = params[:id]
		@task   = Task.find(id)
	end

	def complete
		id      = params[:id]
		task   = Task.find(id)

		task.complete_flag = 1
		task.updated_at = Time.now.strftime('%Y-%m-%d')
		task.save

		redirect_to '/', notice: 'タスクを完了しました。'
	end

	def update
		id   = params[:id]
		task = Task.find(id)

		task.task       = params[:task]
		task.date      = params[:date]
		task.time      = params[:time]
		task.updated_at = Time.now.strftime('%Y-%m-%d')
		task.save

		redirect_to '/', notice: 'タスクを更新しました。'
	end

	def destroy
		id = params[:id]
		task       = Task.find(id)
		task.destroy
		redirect_to '/', notice: 'タスクを削除しました。'
	end

	private
		def move_to_signed_in
			unless user_signed_in?
			#サインインしていないユーザーはログインページが表示される
			redirect_to  '/users/sign_in'
		end
	end

end
