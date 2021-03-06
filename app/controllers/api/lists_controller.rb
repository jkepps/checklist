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

	def update
		list = List.find(params[:id])

		if list.update(list_params)
			render json: list
		else
			unprocessable_entity(list)
		end
	end

	def destroy
		begin
			user = User.find(params[:user_id])
			list = user.lists.find(params[:id])
			list.destroy
			render json: {message: "List destroyed", status: 200}, status: 200
		rescue
			render json: {message: "List not found", status: 204}, status: 204
		end
	end

	private
	def list_params
		params.require(:list).permit(:name, :permissions)
	end
end
