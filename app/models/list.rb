class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  PERMISSION_OPTIONS = %W(closed viewable open)

  before_save { self.permissions ||= :open}
  enum permissions: [:closed, :viewable, :open]

  validates :name, length: { minimum: 1 }, presence: true

  validates :permissions, inclusion: { in: PERMISSION_OPTIONS }

end
