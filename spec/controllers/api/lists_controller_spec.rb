require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
	let (:my_user) { create(:user) }

	context "unauthenticated user" do
		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create, user_id: my_user.id, list: { name: "list" }
				expect(response).to have_http_status(401)
			end
		end
	end

	context "authenticated user" do
		before do
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end

		describe "POST create" do
			context "unprocessable entity" do
				before { post :create, user_id: my_user.id, list: { name: ""} }

				it "returns http unprocessable entity" do
					expect(response).to have_http_status(:unprocessable_entity)
				end
			end

			context "processable entity" do
				before do
					@new_list = build(:list)
					post :create, user_id: my_user.id, list: { name: @new_list.name }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a list with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_list.name).to eq hashed_json["name"]
				end
			end
		end
	end
end
