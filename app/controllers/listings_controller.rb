class ListingsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.build(params[:listing])
    if @listing.save
      flash[:success] = "Your Listing has been successfully created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @listing.destroy
    redirect_to root_url
  end

  private
    def correct_user
      @listing = current_user.listings.find_by_id(params[:id])
      redirect_to root_url if @listing.nil?
    end
end