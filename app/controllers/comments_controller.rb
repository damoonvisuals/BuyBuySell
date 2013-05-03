class CommentsController < ApplicationController

  def new

  end

  def create
    @listing = Listing.find(params[:listing_id])
    @comment = @listing.comments.create(params[:comment]) 
    if signed_in?
      @comment.user_id = current_user.id
    end
    if @comment.save
      redirect_to @listing
    end
  end

end