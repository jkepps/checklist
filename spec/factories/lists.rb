FactoryGirl.define do
	sequence :name do |n|
		"List#{n}"
	end

  factory :list do
    name
    permissions 2
  end

end
