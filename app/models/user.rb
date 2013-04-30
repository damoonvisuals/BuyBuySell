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
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :user_name, :password, :password_confirmation, :remember_me, :login, :provider, :uid
  attr_accessor :login
  # attr_accessible are protected from XSS
  # attr_accessible :email, :user_name, :password, :password_confirmation
  # has_secure_password
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

  VALID_USER_NAME_REGEX = /^[a-z0-9_-]+$/i
  validates :user_name, presence: true, length: {minimum:3, maximum: 15}, uniqueness: {case_sensitive: false}, format: { with: VALID_USER_NAME_REGEX}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  # VALID_PASSWORD_REGEX = /\d/
  # validates :password, length: { minimum: 7 }, format: { with: VALID_PASSWORD_REGEX }

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

  def star!(listing)
    self.listing_relationships.create!(followed_id: listing.id)
  end

  def unstar!(listing)
    self.listing_relationships.find_by_followed_id(listing.id).destroy
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # def self.find_for_twitter_oauth(auth, signed_in_resource=nil)

  #   user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #   if user
  #     return user
  #   else
  #     registered_user = User.where(:email => auth.uid + "@twitter.com").first
  #     if registered_user
  #       return registered_user
  #     else
  #       user = User.create(user_name:auth.info.nickname,
  #         provider:auth.provider,
  #         uid:auth.uid,
  #         email:auth.uid+"@twitter.com")
  #     end
  #   end
  # end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(user_name:auth.extra.raw_info.name.gsub!(/\s/, ''),
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email)
      end

    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(user_name: data["email"][0..data["email"].index("@")-1],
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid)
      end
    end
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.user_name = auth.info.nickname
      user.email = auth.uid + "@twitter.com"
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  # def password_required?
  #   super if confirmed?
  # end

 #  def password_match?
 #   self.errors[:password] << "can't be blank" if password.blank?
 #   self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
 #   self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
 #   password == password_confirmation && !password.blank?
 # end

 def password_required?
  super && provider.blank?
end

def update_with_password(params, *options)
  if encrypted_password.blank?
    update_attributes(params, *options)
  else
    super
  end
end

  # Makes method private, can't be accessed from outside
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
