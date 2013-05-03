class Bid < ActiveRecord::Base
  attr_accessible :amount, :user_id

  belongs_to :biddable, polymorphic: true
  belongs_to :user, foreign_key: "user_id"

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  default_scope :order => 'amount DESC'

end
