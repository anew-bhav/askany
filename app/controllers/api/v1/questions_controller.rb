module Api
  module V1
    class QuestionsController < ApiController
      def ask_question
        question = Question.find_or_initialize_by(query: question_params[:query])
        if question.persisted? && question.answer.present?
          question.ask_count += 1
          question.save
          render json: {answer: question.answer, success: true}, status: :ok
        else
          response = AnswerGeneration.new(question_params[:query]).call
          if response[:success]
            question.answer = response[:data][:answer]
            question.context = response[:data][:context]
            if question.save
              render json: { answer: response[:data][:answer], success: true }, status: :ok
            else
              render json: { success: false }, status: :internal_server_error
            end
          else
            render json: { success: false }, status: :bad_request
          end
        end
      rescue => e
        render json: { success: false , message: "#{e.message}"}, status: :internal_server_error
      end

      private

      def question_params
      params.require(:question).permit(:query)
      end
    end
  end
end