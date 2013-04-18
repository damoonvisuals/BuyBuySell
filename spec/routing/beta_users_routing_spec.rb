require "spec_helper"

describe BetaUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/beta_users").should route_to("beta_users#index")
    end

    it "routes to #new" do
      get("/beta_users/new").should route_to("beta_users#new")
    end

    it "routes to #show" do
      get("/beta_users/1").should route_to("beta_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/beta_users/1/edit").should route_to("beta_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/beta_users").should route_to("beta_users#create")
    end

    it "routes to #update" do
      put("/beta_users/1").should route_to("beta_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/beta_users/1").should route_to("beta_users#destroy", :id => "1")
    end

  end
end
