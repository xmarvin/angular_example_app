# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

json = File.read('db/staff.json')
users_data = JSON.parse(json)
now = Time.current.to_i
users_data.each do |user_attrs|
  User.create! age: user_attrs['age'].to_i,
               position: user_attrs['job'],
               name: user_attrs['name'],
               grade: user_attrs['grade'],
               email: "email-#{now}@da.com",
               password: 'qweqweqwe1'
  now += 1
end