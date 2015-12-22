class Api::ItemsController < ApiController
	before_filter :authenticate_user

	def index
		list = List.find(params[:list_id])
		items = list.items

		render json: items, each_serializer: ItemSerializer, status: 200
	end

	def create
		item = Item.new(item_params)

		if item.save
			render json: item
		else
			unprocessable_entity(item)
		end
	end

	def update
		list = List.find(params[:list_id])
		item = list.items.find(params[:id])

		if item.update(item_params)
			render json: item
		else
			unprocessable_entity(item)
		end
	end

	private
	def item_params
		params.require(:item).permit(:description, :completed)
	end
end
