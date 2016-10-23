require 'rails_helper'

RSpec.describe(API::V1::ItemsController, type: :routing) do
  describe("Routing") do
    let(:item_id) { 1 }

    # Delete
    it "routes DELETE /api/v1/items/:id" do
      expect(
          delete: "/api/v1/items/#{item_id}"
      ).to route_to action:     "destroy",
                    controller: "api/v1/items",
                    format:     :json,
                    id:         item_id.to_s

    end

    # Get
    it "routes GET /api/v1/items" do
      expect(
          get: "/api/v1/items"
      ).to route_to action:     "index",
                    controller: "api/v1/items",
                    format:     :json
    end

    it "routes GET /api/v1/items/:id" do
      expect(
          get: "/api/v1/items/#{item_id}"
      ).to route_to action:     "show",
                    controller: "api/v1/items",
                    format:     :json,
                    id:         item_id.to_s
    end

    # Patch
    it "routes PATCH /api/v1/items/:id" do
      expect(
          patch: "/api/v1/items/#{item_id}"
      ).to route_to action:     "update",
                    controller: "api/v1/items",
                    format:     :json,
                    id:         item_id.to_s
    end

    # Post
    it "routes POST /api/v1/items" do
      expect(
          post: "/api/v1/items"
      ).to route_to action:     "create",
                    controller: "api/v1/items",
                    format:     :json
    end

    # Put
    it "routes PUT /api/v1/items/:id" do
      expect(
          put: "/api/v1/items/#{item_id}"
      ).to route_to action:     "update",
                    controller: "api/v1/items",
                    format:     :json,
                    id:         item_id.to_s
    end
  end
end