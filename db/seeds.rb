# Create users
5.times do
	User.create(
		username: Faker::Internet.user_name,
		email: Faker::Internet.email
	)
end

users = User.all

# Create lists
10.times do
	List.create(
		name: Faker::Lorem.word,
		user: users.sample
	)
end

lists = List.all

# Create items
100.times do
	Item.create(
		description: Faker::Lorem.sentence,
		list: lists.sample
	)
end

puts "#{User.count} users created."
puts "#{List.count} lists created."
puts "#{Item.count} items created." 