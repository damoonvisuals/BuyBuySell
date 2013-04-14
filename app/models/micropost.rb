class Micropost < ActiveRecord::Base
  attr_accessible :content, :tag_list
  belongs_to :user

  acts_as_taggable
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  # Returns microposts from the users being followed by the given user.
  # SELECT * FROM microposts WHERE user_id IN (SELECT followed_id FROM relationships WHERE follower_id = 1) R user_id = 1
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end
