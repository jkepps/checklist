class Api::ItemsController < ApiController
	before_filter :authenticate_user

	def create
		item = Item.new(item_params)

		if item.save
			render json: item
		else
			unprocessable_entity(item)
		end
	end

	private
	def item_params
		params.require(:item).permit(:description)
	end
end
