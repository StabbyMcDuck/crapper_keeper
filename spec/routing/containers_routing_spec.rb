require 'rails_helper'

RSpec.describe(API::V1::ContainersController, type: :routing) do
  describe("Routing") do
    let(:container_id) { 1 }

    # Delete
    it "routes DELETE /api/v1/containers/:id" do
      expect(
          delete: "/api/v1/containers/#{container_id}"
      ).to route_to action:     "destroy",
                    controller: "api/v1/containers",
                    format:     :json,
                    id:         container_id.to_s

    end

    # Get
    it "routes GET /api/v1/containers" do
      expect(
          get: "/api/v1/containers"
      ).to route_to action:     "index",
                    controller: "api/v1/containers",
                    format:     :json
    end

    it "routes GET /api/v1/containers/:id" do
      expect(
          get: "/api/v1/containers/#{container_id}"
      ).to route_to action:     "show",
                    controller: "api/v1/containers",
                    format:     :json,
                    id:         container_id.to_s
    end

    # Patch
    it "routes PATCH /api/v1/containers/:id" do
      expect(
          patch: "/api/v1/containers/#{container_id}"
      ).to route_to action:     "update",
                    controller: "api/v1/containers",
                    format:     :json,
                    id:         container_id.to_s
    end

    # Post
    it "routes POST /api/v1/containers" do
      expect(
          post: "/api/v1/containers"
      ).to route_to action:     "create",
                    controller: "api/v1/containers",
                    format:     :json
    end

    # Put
    it "routes PUT /api/v1/containers/:id" do
      expect(
          put: "/api/v1/containers/#{container_id}"
      ).to route_to action:     "update",
                    controller: "api/v1/containers",
                    format:     :json,
                    id:         container_id.to_s
    end
  end
end