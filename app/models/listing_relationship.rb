class ListingRelationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "Listing"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
