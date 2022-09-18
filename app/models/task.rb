class Task < ApplicationRecord
	belongs_to :user, foreign_key: 'email', primary_key: 'email'

	validates :task, presence: true

end
