FactoryGirl.define do
	sequence :email do |n|
		"user#{n}@factory.com"
	end

  factory :user do
		email
    username Faker::Internet.user_name
  end

end
