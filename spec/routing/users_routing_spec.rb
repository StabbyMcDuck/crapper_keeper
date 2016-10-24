require 'rails_helper'

RSpec.describe(API::V1::UsersController, type: :routing) do
  describe("Routing") do
    let(:user_id) { 1 }

    # Delete
    it "does not route DELETE /api/v1/users/:id" do
      expect(
          delete: "/api/v1/users/#{user_id}"
      ).not_to be_routable
    end

    # Get
    it "routes GET /api/v1/users" do
      expect(
          get: "/api/v1/users"
      ).to route_to action:     "index",
                    controller: "api/v1/users",
                    format:     :json
    end

    it "routes GET /api/v1/users/:id" do
      expect(
          get: "/api/v1/users/#{user_id}"
      ).to route_to action:     "show",
                    controller: "api/v1/users",
                    format:     :json,
                    id:         user_id.to_s
    end

    # Patch
    it "does not route PATCH /api/v1/users/:id" do
      expect(
          patch: "/api/v1/users/#{user_id}"
      ).not_to be_routable
    end

    # Post
    it "does not route POST /api/v1/users" do
      expect(
          post: "/api/v1/users"
      ).not_to be_routable
    end

    # Put
    it "does not route PUT /api/v1/users/:id" do
      expect(
          put: "/api/v1/users/#{user_id}"
      ).not_to be_routable
    end
  end
end