class ListSerializer <  BaseSerializer
	attributes :name, :permissions

  has_many :items
end
