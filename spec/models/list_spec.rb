require 'rails_helper'

RSpec.describe List, type: :model do
	let(:user) { create(:user) }
	let(:list) { create(:list) }

	it { should belong_to(:user) }
	it { should have_many(:items) }

	# Shoulda tests for name
	it { should validate_presence_of(:name) }
	it { should validate_length_of(:name).is_at_least(1) }

	describe "attributes" do
		it "should respond to name" do
			expect(list).to respond_to(:name)
		end
	end

	describe "an invalid list" do
		let(:list_with_invalid_name) { build(:list, name:'') }

		it "should be an invalid list due to blank name" do
			expect(list_with_invalid_name).to_not be_valid
		end
	end
end
