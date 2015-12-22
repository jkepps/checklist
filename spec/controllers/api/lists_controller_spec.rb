require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
	let (:my_user) { create(:user) }
	let (:my_list) { create(:list, user: my_user) }

	context "unauthenticated user" do
		describe "GET index" do
			it 'returns http unauthenticated' do
				get :index, user_id: my_user.id
				expect(response).to have_http_status(401)
			end
		end

		describe "GET show" do
			it "returns http unauthenticated" do
				get :show, user_id: my_user.id, id: my_list.id
				expect(response).to have_http_status(401)
			end
		end

		describe "POST create" do
			it 'returns http unauthenticated' do
				post :create, user_id: my_user.id, list: { name: "list" }
				expect(response).to have_http_status(401)
			end
		end

		describe "PUT update" do
			it "returns http unauthenticated" do
				put :update, user_id: my_user.id, id: my_list.id, list: { permissions: :closed }
				expect(response).to have_http_status(401)
			end
		end

		describe "DELETE destroy" do
			it 'returns http unauthenticated' do
				delete :destroy, user_id: my_user.id, id: my_list.id
				expect(response).to have_http_status(401)
			end
		end
	end

	context "authenticated user" do
		before do
			controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
		end

		describe "GET index" do
			before { get :index, user_id: my_user.id }

			it "returns http success" do
				expect(response).to have_http_status(:success)
			end

			it "returns json content type" do
				expect(response.content_type).to eq 'application/json'
			end

			it "returns serialized version all lists" do
				# hashed_json = JSON.parse(response.body)
				# puts "*" * 20
				# puts response.body.inspect
				# puts "*" * 20
				# puts my_user.lists.inspect
				# expect(hashed_json["lists"]).to eq [my_list]
			end
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
					@new_list = build(:list, user_id: my_user.id)
					post :create, user_id: my_user.id, list: { name: @new_list.name, permissions: @new_list.permissions }
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "creates a list with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_list.name).to eq hashed_json["list"]["name"]
				end
			end
		end

		describe "PUT update" do
			context "unprocessable entity" do
				before { put :update, user_id: my_user.id, id: my_list.id, list: { name: "" } }

				it "returns http unprocessable entity" do
					expect(response).to have_http_status(:unprocessable_entity)
				end
			end

			context "processable entity" do
				before do
					@new_list_name = "New List Name"
					@new_list_permissions = "closed"
					put :update, user_id: my_user.id, id: my_list.id, list: { name: @new_list_name, permissions: @new_list_permissions}
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do 
					expect(response.content_type).to eq 'application/json'
				end

				it "updates the list with the correct attributes" do
					hashed_json = JSON.parse(response.body)
					expect(@new_list_name).to eq hashed_json["list"]["name"]
					expect(@new_list_permissions).to eq hashed_json["list"]["permissions"]
				end
			end
		end

		describe "DELETE destroy" do
			context "list exists" do
				before do
					delete :destroy, user_id: my_user.id, id: my_list.id
				end

				it "returns http success" do
					expect(response).to have_http_status(:success)
				end

				it "returns json content type" do
					expect(response.content_type).to eq 'application/json'
				end

				it "returns the correct json success message" do
					expect(response.body).to eq({"message" => "List destroyed", "status" => 200}.to_json)
				end

				it "deletes my_list" do
					expect{ List.find(my_list.id) }.to raise_exception(ActiveRecord::RecordNotFound)
				end
			end

			context "list doesn't exist" do
				before do
					delete :destroy, user_id: my_user.id, id: 99
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
