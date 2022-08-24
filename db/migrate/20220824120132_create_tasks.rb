class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :task
      t.date :date
      t.timestamp :created_at
      t.timestamp :updated_at

    end
  end
end
