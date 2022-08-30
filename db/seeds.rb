# user = User.new(
# 	:email => 'test@test.com', :password =>'password123'
# )
# user.save!

Task.create!(
[
	{ email: 'test@test.com', task: '牛乳を買う', date: '2022-08-30', created_at: '2022-08-25' },
	{ email: 'test@test.com', task: '手紙を郵送する', date: '2022-08-31', created_at: '2022-08-25' },
]
)


