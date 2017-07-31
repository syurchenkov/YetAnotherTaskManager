# ADMIN
User.create!(email: 'admin@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true)
# REGULAR USER
User.create!(email: 'user@example.com',
             password: 'password',
             password_confirmation: 'password')
