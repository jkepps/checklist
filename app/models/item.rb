class Item < ActiveRecord::Base
  belongs_to :list

  validates :description, length: { minimum: 1 }, presence: true
end
