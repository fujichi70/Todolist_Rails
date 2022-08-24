users = [
{ email: 'test1@test.com', password: 'password123' },
{ email: 'test2@test.com', password: 'password123' },
]

users.each do |record|
 User.create(record) unless User.find_by(email: record[:email])
end

tasks = Task.create([
{ task: '牛乳を買う', state: 'todo', limit_date: '2022-8-30' },
{ task: '手紙を郵送する', state: 'todo', limit_date: '2022-8-31' },
])

