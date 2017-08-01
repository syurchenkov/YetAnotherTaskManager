# ADMIN
User.create!(email: 'admin@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true)
# REGULAR USER
User.create!(email: 'user@example.com',
             password: 'password',
             password_confirmation: 'password')
# 99 REGULAR USERS
99.times do |n|
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(email: email,
               password:              password,
               password_confirmation: password)
end
