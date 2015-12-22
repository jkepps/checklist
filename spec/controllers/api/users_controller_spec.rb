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
				get :show, id: my_user.id
				expect(response).to have_http_status(401)
			end
		end

		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create
				expect(response).to have_http_status(401)
			end
		end

		describe "DELETE destroy" do
			it 'returns http unauthenticated' do
				delete :destroy, id: my_user.id
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
				hashed_json = JSON.parse(response.body)
				expect(hashed_json["users"].first["email"]). to eq my_user.email
				expect(hashed_json["users"].first["username"]). to eq my_user.username
				expect(hashed_json["users"].first["lists"]). to eq my_user.lists
			end
		end

		describe "GET show" do
			before { get :show, id: my_user.id }

			it "returns http success" do
				expect(response).to have_http_status(:success)
			end

			it "returns json content type" do
				expect(response.content_type).to eq 'application/json'
			end

			it "returns the correct user" do
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
					@new_user = { username: "username", email: "username@example.com", password: "password" }
					post :create, user: { username: @new_user[:username], email: @new_user[:email], password: @new_user[:password] }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a user with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(hashed_json["username"]).to eq @new_user["username"]
					expect(hashed_json["email"]).to eq @new_user["email"]
				end
			end
		end

		describe "DELETE destroy" do
			context "user exists" do
				before do
					delete :destroy, id: my_user.id
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "returns the correct json success message" do
					expect(response.body).to eq({"message" => "User destroyed", "status" => 200}.to_json)
				end

				it "deletes my_user" do
					expect{ User.find(my_user.id) }.to raise_exception(ActiveRecord::RecordNotFound)
				end
			end

			context "user doesn't exist" do
				before do
					delete :destroy, id: 99
				end

				it "returns http 204" do
					expect(response).to have_http_status(204)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end
			end
		end
	end
end
