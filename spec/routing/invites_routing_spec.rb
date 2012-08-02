require "spec_helper"

describe InvitesController do
  describe "routing" do

    it "routes to #index" do
      get("/invites").should route_to("invites#index")
    end

    it "routes to #new" do
      get("/invites/new").should route_to("invites#new")
    end

    it "routes to #show" do
      get("/invites/1").should route_to("invites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/invites/1/edit").should route_to("invites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/invites").should route_to("invites#create")
    end

    it "routes to #update" do
      put("/invites/1").should route_to("invites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/invites/1").should route_to("invites#destroy", :id => "1")
    end

  end
end
