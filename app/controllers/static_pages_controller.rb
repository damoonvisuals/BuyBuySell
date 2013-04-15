class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @listing = current_user.listings.build
      if params[:tag]
        @feed_items = current_user.feed.tagged_with(params[:tag]).paginate(page: params[:page])
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
    end
  end    

  def help
  end

  def about
    
  end

  def contact

  end

  def projects
  end
end
