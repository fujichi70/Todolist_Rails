class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :email, null: false
      t.string :task, null: false
      t.date :date
      t.text :time
      t.integer :complete_flag
      t.date :created_at, null: false
      t.date :updated_at
    end
  end
end
