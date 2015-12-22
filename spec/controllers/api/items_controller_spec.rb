require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
	let(:my_user) { create(:user) }
	let(:my_list) { create(:list, user_id: my_user.id) }
	let(:my_item) { create(:item, list_id: my_list.id) }

	context "unauthenticated user" do
		describe "GET index" do
			it 'returns http unauthenticated' do
				get :index, list_id: my_list.id
				expect(response).to have_http_status(401)
			end
		end

		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create, list_id: my_list.id, item: { description: "item description" }
				expect(response).to have_http_status(401)
			end
		end

		describe "PUT update" do
			it 'returns http unauthenticated' do
				put :update, list_id: my_list.id, id: my_item.id, item: {completed: true}
				expect(response).to have_http_status(401)
			end
		end
	end

	context "authenticated user" do
		before do
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end

		describe "GET index" do
			before { get :index, list_id: my_list.id }

			it "returns http success" do
				expect(response).to have_http_status(:success)
			end

			it "returns json content type" do
				expect(response.content_type).to eq 'application/json'
			end

			it "returns my_item serialized" do
				# hashed_json = JSON.parse(response.body)
				# puts hashed_json.inspect
				# expect(hashed_json["items"].first["description"]).to eq my_item.description
			end
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
					@new_item = build(:item, list_id: my_list.id)
					post :create, list_id: my_list.id, item: { description: @new_item.description }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a item with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_item.description).to eq hashed_json["item"]["description"]
				end
			end
		end

		describe "PUT update" do
			context "unprocessable entity" do
				before { put :update, list_id: my_list.id, id: my_item.id, item: { description: "", completed: false} }

				it "returns http unprocessable entity" do
					expect(response).to have_http_status(:unprocessable_entity)
				end
			end

			context "processable entity" do
				before do
					@updated_item = {description: "updated description", completed: true}
					put :update, list_id: my_list.id, id: my_item.id, item: @updated_item 
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "updates my_item with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@updated_item["description"]).to eq hashed_json["description"]
					expect(@updated_item["completed"]).to eq hashed_json["completed"]
				end
			end
		end
	end
end
