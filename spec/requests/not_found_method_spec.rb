require "rails_helper"

RSpec.describe "*", type: :request do
  let(:route) { "/#{SecureRandom.hex(4)}" }

  context "GET /random_route" do
    it "should respond with 404" do
      get route
      expect(response.code.to_i).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(false)
      expect(response_body["message"]).to eq("This route is not supported")
    end
  end

  context "POST /random_route" do
    it "should respond with 404" do
      post route
      expect(response.code.to_i).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(false)
      expect(response_body["message"]).to eq("This route is not supported")
    end
  end

  context "PUT /random_route" do
    it "should respond with 404" do
      put route
      expect(response.code.to_i).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(false)
      expect(response_body["message"]).to eq("This route is not supported")
    end
  end

  context "PATCH /random_route" do
    it "should respond with 404" do
      patch route
      expect(response.code.to_i).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(false)
      expect(response_body["message"]).to eq("This route is not supported")
    end
  end

  context "DELETE /random_route" do
    it "should respond with 404" do
      delete route
      expect(response.code.to_i).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(false)
      expect(response_body["message"]).to eq("This route is not supported")
    end
  end

  context "HEAD /random_route" do
    it "should respond with 404" do
      head route
      expect(response.code.to_i).to eq(404)
    end
  end
end
