class Api::UsersController < ApiController
	before_filter :authenticate_user

	def index
		users = User.all
		render json: users, each_serializer: UserSerializer, status: 200
	end

	def show
		user = User.find(params[:id])
		render json: user
	end

	def create
		user = User.new(user_params)
		if user.save
			render json: user
		else
			unprocessable_entity(user)
		end
	end

	def destroy
		begin
			user = User.find(params[:id])
			user.destroy
			render json: {message: "User destroyed", status: 200}, status: 200
		rescue ActiveRecord::RecordNotFound
			render json: {message: "User not found", status: 204}, status: 204
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :username, :password)
	end
end