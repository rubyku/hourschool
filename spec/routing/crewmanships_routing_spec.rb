require "spec_helper"

describe CrewmanshipsController do
  describe "routing" do

    it "routes to #index" do
      get("/crewmanships").should route_to("crewmanships#index")
    end

    it "routes to #new" do
      get("/crewmanships/new").should route_to("crewmanships#new")
    end

    it "routes to #show" do
      get("/crewmanships/1").should route_to("crewmanships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/crewmanships/1/edit").should route_to("crewmanships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/crewmanships").should route_to("crewmanships#create")
    end

    it "routes to #update" do
      put("/crewmanships/1").should route_to("crewmanships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/crewmanships/1").should route_to("crewmanships#destroy", :id => "1")
    end

  end
end
