require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
	let(:my_user) { create(:user) }
	let(:my_list) { create(:list) }

	context "unauthenticated user" do
		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create, list_id: my_list.id, item: { description: "item description" }
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
				before { post :create, list_id: my_list.id, item: { description: "" } }

				it "returns http unprocessable entity" do
					expect(response).to have_http_status(:unprocessable_entity)
				end
			end

			context "processable entity" do
				before do
					@new_item = build(:item)
					post :create, list_id: my_list.id, item: { description: "item description" }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a item with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_item.description).to eq hashed_json["description"]
				end
			end
		end
	end
end
