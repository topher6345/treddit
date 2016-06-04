# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "benchmark"

SUBTREDDITS = 400
USERS = 1200
POSTS = 2200
COMMENTS = 6800

time = Benchmark.measure do

ActiveRecord::Base.logger = nil
  if Post.all.present?
    puts 'Please drop database first'
    exit(1)
  end

  ActionMailer::Base.perform_deliveries = false
  require 'faker'

  PASSWORD = 'asdfjkl;'
  subtreddit_names = %w(Ruby Rails Music News Programming)

  subtreddits = []
  subtreddit_names.each do |name|
    subtreddits << Subtreddit.create!(name: name, description: Faker::Commerce.department)
  end

  SUBTREDDITS.times do
    begin
      subtreddits << Subtreddit.create!(
        name: Faker::Company.buzzword, description: Faker::Commerce.department)
    rescue
    end
  end

  users = []

  root_user = User.create!(email: 'topher6345@gmail.com',
                           password: ENV['SEED_PASSWORD'],
                           password_confirmation: ENV['SEED_PASSWORD']).confirm

  USERS.times do
    user = User.create!(email: Faker::Internet.email,
                        password: PASSWORD,
                        password_confirmation: PASSWORD)
    user.confirm
    users << user
  end

  posts = []
  posts << Post.create!(title: 'README',
                        body: File.read(Rails.root.join('README.md')),
                        user: users.sample,
                        subtreddit: subtreddits.sample)

  POSTS.times do
    posts << Post.create!(title: Faker::Company.catch_phrase,
                          body: [
                            Faker::Hacker.say_something_smart,
                            Faker::Hipster.paragraphs(rand(4) + 1).join(''),
                            Faker::Hipster.sentences(rand(4) + 1).join(''),
                            Faker::Superhero.name,
                            Faker::StarWars.quote,
                            [Faker::Superhero.power, Faker::Name.name].join(' ')
                          ].sample,

                          user: users.sample,
                          subtreddit: subtreddits.sample)
  end

  COMMENTS.times do
    posts << Comment.create!(body: [
                            Faker::Hacker.say_something_smart,
                            Faker::Hipster.paragraphs(rand(4) + 1).join(''),
                            Faker::Hipster.sentences(rand(4) + 1).join(''),
                            Faker::Superhero.name,
                            Faker::StarWars.quote,
                            [Faker::Superhero.power, Faker::Name.name].join(' ')
                          ].sample,
                             user: users.sample,
                             parent: posts.sample)
  end

  while(Vote.count < 40)
    Upvote.create!(user: users.sample, post: posts.sample) rescue Upvote::DuplicateUpvote
  end


  ActionMailer::Base.perform_deliveries = true
end

puts time