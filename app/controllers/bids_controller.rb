class BidsController < ApplicationController
  before_filter :get_biddable

  def index
    @bids = @biddable.bids
  end

  def create
    @bid = @biddable.bids.create(params[:bid]) 
    if @bid.save
      redirect_to @biddable
    else 
      flash[:error] = "You fucked up"
      redirect_to @biddable
    end
  end

  private
    # def load_biddable
    #   resource, id = request.path.split('/')[1,2]
    #   @biddable = resource.singularize.classify.constantize.find(id) #Listing.find(id)
    # end

    def get_biddable
      @biddable = params[:biddable].classify.constantize.find(biddable_id)
    end

    def biddable_id
      params[(params[:biddable].singularize + "_id").to_sym]
    end

end