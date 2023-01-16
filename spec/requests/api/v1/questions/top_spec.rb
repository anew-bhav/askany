require "rails_helper"

RSpec.describe "Api::V1::QuestionsController", type: :request do
  context "POST /api/v1/top" do
    let!(:questions) { create_list(:question, 12) }
    subject(:top_request) { get "/api/v1/top" }
    it "should respond with list of top 10 questions by ask_count" do
      top_request
      excluded_questions = Question.order(ask_count: :asc).limit(2).pluck(:query)
      included_questions = Question.order(ask_count: :desc).limit(10).pluck(:query)
      expect(response.code.to_i).to eq(200)
      response_body = JSON.parse(response.body)
      expect(response_body["success"]).to eq(true)
      expect(response_body["data"]["top_questions"]).to match_array(included_questions)
    end
  end
end
