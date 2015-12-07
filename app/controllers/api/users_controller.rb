class Api::UsersController < ApiController
	before_filter :authenticate_user

	def index
		users = User.all
		render json: users, each_serializer: UserSerializer, status: 200
	end
end