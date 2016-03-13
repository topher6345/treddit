# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActionMailer::Base.perform_deliveries = false

require 'faker'


PASSWORD = 'asdfjkl;'
subtreddit_names = %w(Ruby Rails Music News Programming)

subtreddits = []
subtreddit_names.each do |name|
  subtreddits << Subtreddit.create!(name: name, description: Faker::Commerce.department)
end

users = []

User.create!(email: 'topher6345@gmail.com',
                      password: PASSWORD,
                      password_confirmation: PASSWORD).confirm

20.times do
  user = User.create!(email: Faker::Internet.email,
                      password: PASSWORD,
                      password_confirmation: PASSWORD)
  user.confirm
  users << user
end

posts = []
20.times do
  posts << Post.create!(title: Faker::Company.catch_phrase,
                        body: Faker::Hacker.say_something_smart,
                        user: users.sample,
                        subtreddit: subtreddits.sample)
end

80.times do
  posts << Comment.create!(body: Faker::Hacker.say_something_smart,
                           user: users.sample,
                           parent: posts.sample)
end

while(Vote.count < 40)
  Upvote.create!(user: users.sample, post: posts.sample) rescue Upvote::DuplicateUpvote
end


ActionMailer::Base.perform_deliveries = true