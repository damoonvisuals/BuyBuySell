class ListingRelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @listing = Listing.find(params[:listing_relationship][:followed_id])
    current_user.follow!(@listing)
    respond_to do |format|
      format.html { redirect_to @listing }
      format.js
    end
  end

  def destroy
    @listing = ListingRelationship.find(params[:id]).followed
    current_user.unfollow!(@listing)
    respond_to do |format|
      format.html { redirect_to @listing }
      format.js
    end
  end
end