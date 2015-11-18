require 'rails_helper'

RSpec.describe Item, type: :model do
	let(:list) { create(:list) }
	let(:item) { create(:item) }

	it { should belong_to(:list) }

	# Shoulda tests for description
	it { should validate_presence_of(:description) }
	it { should validate_length_of(:description) } 

	describe "attributes" do
		it "responds to description" do
			expect(item).to respond_to(:description)
		end
	end

	describe "invalid item" do
		let(:item_with_invalid_description) { build(:item, description: '') }

		it "should be an invalid item due to blank description" do
			expect(item_with_invalid_description).to_not be_valid
		end
	end
end
