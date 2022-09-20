class DonesController < ApplicationController
  before_action :move_to_signed_in

  def index(done_id: nil)
    user = current_user.email
    time = Time.current.strftime("%Y-%m-%d")
    @done = Done.where(email: user, date: time).and(Done.where.not(end_time: nil))
    @newDone = Done.where(done_id: done_id)
  end

  def start(done_id:, keep_id: nil, date:, done: nil, description: nil)
    if !date.present?
     return redirect_to '/dones', alert: '日付は必ず入力してください。'
    end

    if keep_id.present?
      keepDone = Done.where(done_id: keep_id)
      keepDone.destroy_all
    end

    @newDone = Done.new

    @newDone.email       = current_user.email
    @newDone.done_id     = done_id
    @newDone.done        = done
    @newDone.date        = date
    @newDone.start_time  = Time.current.strftime('%H:%M')
    @newDone.description = description
    @newDone.created_at  = Time.current.strftime('%Y-%m-%d')
    @newDone.save

    return redirect_to dones_url(done_id: done_id)
  end

  def end(keep_id: nil, done_id: nil, done: nil, description: nil)
    if !keep_id.present?
     return redirect_to '/dones' , alert: '最初からやり直してください。'
    end

    newDone = Done.where(done_id: keep_id)

    newDone.each do |n|
      if !n.done.present? && !done.present?
        done_id = keep_id
        return redirect_to dones_url(done_id: done_id), alert: 'やったことが未入力です。'
      end

      if !n.done.present?
        n.done = done
      end	

      if !n.description.present?
        n.description = description
      end

      n.end_time   = Time.current.strftime('%H:%M')
      n.created_at  = Time.current.strftime('%Y-%m-%d')
      n.save
      return redirect_to '/dones', notice: 'やったことを追加しました。'
    end
  end

  def add(done_id:, done: nil, date: nil, start_time: nil, end_time: nil, description: nil)
    if !done.present? || !date.present?
      return redirect_to '/dones' , alert: '最初からやり直してください。'
    end

    if start_time > end_time
      return redirect_to '/dones', alert: '開始時刻と終了時刻が前後しています。'
    end

    newDone = Done.new

    newDone.email       = current_user.email
    newDone.done_id     = done_id
    newDone.done        = done
    newDone.date        = date
    newDone.start_time  = start_time
    newDone.end_time    = end_time
    newDone.description = description
    newDone.created_at  = Time.current.strftime('%Y-%m-%d')
    newDone.save

    return redirect_to '/dones', notice: 'やったことを追加しました'
  end

  def show(id:)
    @done = Done.find(id)
  end

  def delete
    done = Done.where(end_time: nil)
    done.destroy_all
    return redirect_to '/dones', alert: 'リセットしました。'
  end

  def update(id:, done:, date:, start_time:, end_time:, description: nil)
    updateDone = Done.find(id)

    if !done.present? && !date.present? && !start_time.present? && !end_time.present?
     return redirect_to request.referer, alert: 'やったことと日付と時間は必ず入力してください。'
    end

    updateDone.done        = done
    updateDone.date        = date
    updateDone.start_time  = start_time
    updateDone.end_time    = end_time
    updateDone.description = description
    updateDone.updated_at  = Time.current.strftime('%Y-%m-%d')
    updateDone.save

    return redirect_to '/dones', notice: '編集しました。'
  end

  def destroy(id:)
    done = Done.find(id)
    done.destroy
    return redirect_to '/dones', alert: 'やったことを削除しました。'
  end

  def csv(selectdate: nil)
    user = current_user.email
    if selectdate.present?
      @done = Done.where(email: user, date: selectdate)
      @date = Done.select(:date).distinct.order(date: :asc)
    else
      @done = Done.where(email: user)
      @date = Done.select(:date).distinct.order(date: :asc)
  end

  # csv出力
    respond_to do |format|
      format.html
      format.csv do
        if selectdate.present?
          user = current_user.email
          @done = Done.where(email: user, date: selectdate)
          csv_output(@done)
        else
          csv_output(@done)
        end
      end
    end
  end

  private
  # 出力データ生成
  def csv_output(dones)
    require 'csv'

    filename = "done_load" + Time.current.strftime("%Y%m%d")
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
      return redirect_to  '/users/sign_in'
    end
  end

end
