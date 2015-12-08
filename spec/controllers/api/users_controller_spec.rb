require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
	let(:my_user) { create(:user) }

	context "unauthenticated users" do
		describe "GET index" do
			it 'returns http unauthenticated' do
				get :index
				expect(response).to have_http_status(401)
			end
		end

		describe "GET show" do
			it "returns http unauthenticated" do
				get :show
				expect(response).to have_http_status(401)
			end
		end

		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create
				expect(response).to have_http_status(401)
			end
		end
	end

	context "authenticated users" do
		before do
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end

		describe "GET index" do
			before { get :index }

			it "returns http success" do
				expect(response).to have_http_status(:success)
			end

			it "returns json content type" do
				expect(response.content_type).to eq 'application/json'
			end

			it "returns my_user serialized" do
				expect(UserSerializer.new(my_user).to_json).to eq response.body
			end
		end

		describe "POST create" do
			context "unprocessable entity" do
				before { post :create, user: { username: "", password: "", email: ""} }

				it "returns http unprocessable entity" do
					expect(response).to have_http_status(:unprocessable_entity)
				end
			end

			context "processable entity" do
				before do
					@new_user = build(:user)
					post :create, user: { username: @new_user.username, email: @new_user.email, password: @new_user.password }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a user with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_user.username).to eq hashed_json["username"]
					expect(@new_user.email).to eq hashed_json["email"]
				end
			end
		end
	end
end
