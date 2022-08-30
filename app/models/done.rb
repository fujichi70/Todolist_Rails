class Done < ApplicationRecord
		belongs_to :user, foreign_key: 'email', primary_key: 'email'
end
