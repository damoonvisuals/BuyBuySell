# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # attr_accessible are protected from XSS
  attr_accessible :email, :user_name, :password, :password_confirmation
  has_secure_password
  acts_as_messageable

  # dependent: :destroy makes listings destroyed when user destroyed
  has_many :listings, dependent: :destroy

  has_many :listing_relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_listings, through: :listing_relationships, source: :followed
  # This is code for followers/followed for users
  # has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # has_many :followed_users, through: :relationships, source: :followed
  # has_many :reverse_relationships, foreign_key: "followed_id",
  #                                  class_name:  "Relationship",
  #                                  dependent:   :destroy
  # has_many :followers, through: :reverse_relationships, source: :follower

  before_save { |user| user.email = email.downcase }
  before_save { |user| user.user_name = user_name.downcase }
  before_save :create_remember_token

  VALID_USER_NAME_REGEX = /^[a-z0-9_-]+$/
  validates :user_name, presence: true, length: {minimum:3, maximum: 15}, uniqueness: {case_sensitive: false}, format: { with: VALID_USER_NAME_REGEX}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  VALID_PASSWORD_REGEX = /\d/
  validates :password, presence: true, length: { minimum: 7 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password_confirmation, presence: true

  def name
    user_name
  end

  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    email
    #if false
    #return nil
  end

  def feed
    Listing.from_users_followed_by(self)
  end

  def following?(listing)
    self.listing_relationships.find_by_followed_id(listing.id)
  end

  def follow!(listing)
    self.listing_relationships.create!(followed_id: listing.id)
  end

  def unfollow!(listing)
    self.listing_relationships.find_by_followed_id(listing.id).destroy
  end

  # Makes method private, can't be accessed from outside
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
