require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { create(:user) }

	it { should have_many(:lists) }

	# Shoulda tests for username
	it { should validate_presence_of(:username) }
	it { should validate_length_of(:username).is_at_least(1) }

	# Shoulda tests for email
	it { should validate_presence_of(:email) }
	it { should validate_length_of(:email).is_at_least(3) }
	it { should validate_uniqueness_of(:email) }
	it { should allow_value('user@example.com').for(:email) }
	it { should_not allow_value('user.com').for(:email) }

	# Shoulda tests for password
	it { should validate_presence_of(:password) }
	it { should validate_length_of(:password).is_at_least(6) }
	it { should have_secure_password }

	describe "attributes" do 
		it "should respond to username" do
			expect(user).to respond_to(:username)
		end

		it "should respond to email" do
			expect(user).to respond_to(:email)
		end

		it "should respond to password" do
			expect(user).to respond_to(:password)
		end
	end

	describe "invalid user" do
		let(:user_with_invalid_username) { build(:user, username: '') }
		let(:user_with_invalid_email) { build(:user, email: '') }
		let(:user_with_invalid_email_format) { build(:user, email: 'be.com') }

		it "should be an invalid user due to blank name" do
			expect(user_with_invalid_username).to_not be_valid
		end

		it "should be an invalid user due to blank email" do
			expect(user_with_invalid_email).to_not be_valid
		end

		it "should be an invalid user due to incorrectly formatted email" do
			expect(user_with_invalid_email_format).to_not be_valid
		end
	end

	describe "#generate_auth_token" do
		it "creates a token" do
			expect(user.auth_token).to_not be_nil
		end
	end
end
