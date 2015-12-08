class Api::ListsController < ApiController
	before_filter :authenticate_user

	def index
		user = User.find(params[:user_id])
		lists = user.lists

		render json: lists, each_serializer: ListSerializer
	end

	def show
		user = User.find(params[:user_id])
		list = user.lists.find(params[:id])

		render json: list
	end

	def create
		list = List.new(list_params)

		if list.save
			render json: list
		else
			unprocessable_entity(list)
		end
	end

	private
	def list_params
		params.require(:list).permit(:name)
	end
end
