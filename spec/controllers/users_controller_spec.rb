require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
	let(:my_user) { create(:user) }

	context "unauthenticated users" do
		it 'GET index returns http unauthenticated' do
			get :index
			expect(response).to have_http_status(401)
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
	end
end
