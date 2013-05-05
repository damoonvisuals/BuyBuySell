class Listing < ActiveRecord::Base
  attr_accessible :title, :description, :image, :tag_list, :price, :followers
  belongs_to :user

  # has_many :listing_relationships, foreign_key: "followed_id", dependent: :destroy
  # has_many :followed_users, through: :listing_relationships, source: :followed

  has_many :reverse_listing_relationships, foreign_key: "followed_id",
                                   class_name:  "ListingRelationship",
                                 dependent:   :destroy
  has_many :followers, through: :reverse_listing_relationships, source: :follower

  has_many :bids, as: :biddable

  mount_uploader :image, ImageUploader
  acts_as_taggable
  acts_as_commentable

  validates :title, presence: true, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  default_scope order: 'listings.created_at DESC'


  include PgSearch
  pg_search_scope :search, against: [:title],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {tags: [:name]}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  # Returns listings from the users being followed by the given user.
  # SELECT * FROM listings WHERE user_id IN (SELECT followed_id FROM listing_relationships WHERE follower_id = 1) R user_id = 1
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM listing_relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

end
