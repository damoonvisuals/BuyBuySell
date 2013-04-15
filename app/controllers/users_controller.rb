class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    # @microposts = @user.microposts.paginate(page: params[:page])
    @listings = @user.listings.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "You have successfully signed up for dasun.us, congratulations!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end

  def edit
    #@user = User.find(params[:id]) Removed because of correct_user
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def following
    @title = "Starred"
    @user = User.find(params[:id])
    @users = @user.followed_listings.paginate(page: params[:page])
    render 'show_follow'
  end

  # def followers
  #   @title = "Followers"
  #   @user = User.find(params[:id])
  #   @users = @user.followers.paginate(page: params[:page])
  #   render 'show_follow'
  # end
  
  private

    def signed_in_user
      #Same as flash[:notice] redirect_to signin_url
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
