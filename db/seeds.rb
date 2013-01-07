# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new()
user.email = 'admin@admin.oiga.me'
user.password = 'oigame'
user.confirmed_at = DateTime.now
user.skip_confirmation!
user.save!
user.roles = %w(admin)
user.save!

campaign = Campaign.new()
campaign.name = 'Los banqueros a las carceles'
campaign.intro = 'Iros ya'
campaign.body = 'Teneis que iros de una vez!!!'
campaign.user = user
campaign.save!
