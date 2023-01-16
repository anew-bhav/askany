require "rails_helper"

RSpec.describe "Api::V1::QuestionsController", type: :request do
  context "POST /api/v1/ask" do
    context "when the query is persisted in the database" do
      context "when persisted query has answer attribute present" do
        context "when question save succeeds" do
          let(:question) { create(:question) }
          subject(:ask_request) { post "/api/v1/ask", params: { question: { query: question.query } } }
          it "should respond with value from database" do
            question
            expect_any_instance_of(AnswerGeneration).to_not receive(:call)
            ask_request
            expect(response.code.to_i).to eq(200)
            expect(JSON.parse(response.body)["answer"]).to eq(question.answer)
          end

          it "should increase the ask_count of the question by 1" do
            question
            ask_count = question.ask_count
            expect_any_instance_of(AnswerGeneration).to_not receive(:call)
            ask_request
            expect(question.reload.ask_count - ask_count).to eq(1)
            expect(response.code.to_i).to eq(200)
            expect(JSON.parse(response.body)["answer"]).to eq(question.answer)
          end
        end
        context "when question ave fails" do
          let(:question) { create(:question) }
          subject(:ask_request) { post "/api/v1/ask", params: { question: { query: question.query } } }
          it "should responsd with failure, should not increase ask_count" do
            question
            ask_count = question.ask_count
            expect_any_instance_of(AnswerGeneration).to_not receive(:call)
            allow_any_instance_of(Question).to receive(:save).and_return(false)
            ask_request
            expect(question.reload.ask_count - ask_count).to eq(0)
            expect(response.code.to_i).to eq(500)
            expect(JSON.parse(response.body)["success"]).to eq(false)
          end
        end
      end

      context "when persisted query does not have answer attribute present" do
        context "when call to Answer Generation service fails" do
          let(:question) { create(:question, answer: nil) }
          subject(:ask_request) { post "/api/v1/ask", params: { question: { query: question.query } } }
          it "should respond with failure" do
            question
            allow_any_instance_of(OpenAI::Client).to receive(:embeddings).and_return({ "data" => [{ "embedding" => [] }] })
            allow_any_instance_of(AnswerGeneration).to receive(:call).and_return({ success: false })
            expect_any_instance_of(AnswerGeneration).to receive(:call).and_return({ success: false })
            ask_request
            expect(response.code.to_i).to eq(400)
            expect(JSON.parse(response.body)["success"]).to eq(false)
          end
        end

        context "when call to Answer Generation serivce succeeds" do
          context "when saving question record to database fails" do
            subject(:ask_request) { post "/api/v1/ask", params: { question: { query: "random" } } }
            it "should respond with failure, a new question is not persisted" do
              allow_any_instance_of(OpenAI::Client).to receive(:embeddings).and_return({ "data" => [{ "embedding" => [] }] })
              allow_any_instance_of(AnswerGeneration).to receive(:call).and_return({ success: true, data: { answer: "answer", context: "context" } })
              expect_any_instance_of(AnswerGeneration).to receive(:call)
              allow_any_instance_of(Question).to receive(:save).and_return(false)
              expect { ask_request }.to change(Question, :count).by(0)
              expect(response.code.to_i).to eq(500)
              expect(JSON.parse(response.body)["success"]).to eq(false)
            end
          end

          context "when saving question record to database success" do
            subject(:ask_request) { post "/api/v1/ask", params: { question: { query: "random" } } }
            it "should respond with success, a new question should be persisted" do
              allow_any_instance_of(OpenAI::Client).to receive(:embeddings).and_return({ "data" => [{ "embedding" => [] }] })
              allow_any_instance_of(AnswerGeneration).to receive(:call).and_return({ success: true, data: { answer: "answer", context: "context" } })
              expect_any_instance_of(AnswerGeneration).to receive(:call)
              expect { ask_request }.to change(Question, :count).by(1)
              question = Question.order(created_at: :desc).first
              expect(question.answer).to eq("answer")
              expect(question.context).to eq("context")
              expect(response.code.to_i).to eq(200)
              expect(JSON.parse(response.body)["success"]).to eq(true)
            end
          end
        end
      end
    end
    context "when unhandled exceptions occur" do
      subject(:ask_request) { post "/api/v1/ask", params: { question: { query: "random" } } }
      it "should should respond with failure response" do
        allow_any_instance_of(OpenAI::Client).to receive(:embeddings).and_raise(StandardError)
        ask_request
        expect(response.code.to_i).to eq(500)
        expect(JSON.parse(response.body)["success"]).to eq(false)
      end
    end
  end
end
