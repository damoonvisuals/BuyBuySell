class CommentsController < ApplicationController

  def new

  end

  def create
    @listing = Listing.find(params[:listing_id])
    @comment = @listing.comments.create(params[:comment]) 
    if @comment.save
      redirect_to @listing
    end
  end

end