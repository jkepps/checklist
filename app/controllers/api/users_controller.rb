class Api::UsersController < ApiController
	before_filter :authenticate_user

	def index
		users = User.all
		render json: users, each_serializer: UserSerializer, status: 200
	end

	def create
		user = User.new(user_params)
		if user.save
			render json: user
		else
			unprocessable_entity(user)
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :username, :password)
	end
end