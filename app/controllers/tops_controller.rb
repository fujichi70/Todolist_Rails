class TopsController < ApplicationController
	before_action :move_to_signed_in, except: [:index]

	def index
		user       = current_user.email
		@tasks     = Task.where(email: user, complete_flag: nil)
		@completes = Task.where(email: user, complete_flag: 1)
	end

	def create(task:, date: nil, time: nil)
		newTask = Task.new
		
		# if task.nil?
			# return redirect_to '/', alert: 'やることを入れてください。'
		# end

    newTask.email         = current_user.email
    newTask.task          = task
    newTask.date          = date
    newTask.time          = time
    newTask.complete_flag = nil
    newTask.created_at    = Time.current.strftime('%Y-%m-%d')
    newTask.save

    return redirect_to '/', notice: 'タスクを追加しました。'
	end

	def show(id:)
		@task = Task.find(id)
	end

	def complete(id:)
		task = Task.find(id)

		task.complete_flag = 1
		task.updated_at    = Time.current.strftime('%Y-%m-%d')
		task.save

		redirect_to '/', notice: 'タスクを完了しました。'
	end

	def update(id:)
		upTask = Task.find(id)

		if task.present?
			upTask.task       = task
			upTask.date       = date
			upTask.time       = time
			upTask.updated_at = Time.current.strftime('%Y-%m-%d')
			upTask.save

			return redirect_to '/', notice: 'タスクを更新しました。'
		else
			return redirect_to request.referer, alert: 'やることを入れてください。'
		end
	end

	def destroy(id:)
		task = Task.find(id)
		task.destroy
		return redirect_to '/', alert: 'タスクを削除しました。'
	end

	private
		# ログインしてない場合ログインページに遷移
		def move_to_signed_in
			unless user_signed_in?
			return redirect_to  '/users/sign_in'
		end
	end

end
