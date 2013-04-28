class ListingsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :edit, :update, :create, :destroy, :followers]
  before_filter :correct_user, only: [:edit, :update, :destroy, :followers]
  before_filter :admin_user, only: [:destroy]

  def show
    @listing = Listing.find(params[:id])
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.build(params[:listing])
    if @listing.save
      flash[:success] = "Your listing has been successfully created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    #@listings = Listing.all
    if params[:tag]
      @listings = Listing.tagged_with(params[:tag]).paginate(page: params[:page])
    else
      @listings = Listing.paginate(page: params[:page])
    end
  end

  def edit

  end

  def update

  end

  def destroy
    @listing.destroy
    redirect_to root_url
  end

  def followers
    @title = "Followers"
    @listing = Listing.find(params[:id])
    @followers = @listing.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  def correct_user
    @listing = current_user.listings.find_by_id(params[:id])
    redirect_to root_url if @listing.nil?
  end
end