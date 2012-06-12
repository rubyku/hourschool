require "spec_helper"

describe MissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/missions").should route_to("missions#index")
    end

    it "routes to #new" do
      get("/missions/new").should route_to("missions#new")
    end

    it "routes to #show" do
      get("/missions/1").should route_to("missions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/missions/1/edit").should route_to("missions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/missions").should route_to("missions#create")
    end

    it "routes to #update" do
      put("/missions/1").should route_to("missions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/missions/1").should route_to("missions#destroy", :id => "1")
    end

  end
end
