class CreateDones < ActiveRecord::Migration[7.0]
  def change
    create_table :dones do |d|
      d.string :email, null: false
      d.string :done_id, null: false
      d.string :done
      d.text :description
      d.date :date, null: false
      d.text :start_time, null: false
      d.text :end_time
      d.date :created_at, null: false
      d.date :updated_at
    end
  end
end
