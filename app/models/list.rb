class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  before_save { self.permissions ||= :open}

  validates :name, length: { minimum: 1 }, presence: true

  enum permissions: [:closed, :viewable, :open]
end
