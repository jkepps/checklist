class Api::ListsController < ApiController
	before_filter :authenticate_user

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
