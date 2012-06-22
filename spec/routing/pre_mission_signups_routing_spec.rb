require "spec_helper"

describe PreMissionSignupsController do
  describe "routing" do

    it "routes to #index" do
      get("/pre_mission_signups").should route_to("pre_mission_signups#index")
    end

    it "routes to #new" do
      get("/pre_mission_signups/new").should route_to("pre_mission_signups#new")
    end

    it "routes to #show" do
      get("/pre_mission_signups/1").should route_to("pre_mission_signups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pre_mission_signups/1/edit").should route_to("pre_mission_signups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pre_mission_signups").should route_to("pre_mission_signups#create")
    end

    it "routes to #update" do
      put("/pre_mission_signups/1").should route_to("pre_mission_signups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pre_mission_signups/1").should route_to("pre_mission_signups#destroy", :id => "1")
    end

  end
end
