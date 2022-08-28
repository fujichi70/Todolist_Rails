class CreateDones < ActiveRecord::Migration[7.0]
  def change
    create_table :dones do |t|
      t.string :email, null: false
      t.string :done, null: false
      t.date :date, null: false
      t.text :start_time, null: false
      t.text :end_time, null: false
      t.date :created_at, null: false
      t.date :updated_at
    end
  end
end
