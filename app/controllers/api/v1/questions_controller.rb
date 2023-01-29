module Api
  module V1
    class QuestionsController < ApiController
      before_action :load_book

      def ask_question
        question = @book.questions.find_or_initialize_by(query: question_params[:query])
        if question.persisted? && question.answer.present?
          question.ask_count += 1
          if question.save
            render json: { answer: question.answer, success: true }, status: :ok
          else
            render json: { success: false }, status: :internal_server_error
          end
        else
          response = AnswerGeneration.new(
            question_params[:query],
            @book
          ).call
          if response[:success]
            question.answer = response[:data][:answer]
            question.context = response[:data][:context]
            if question.save
              render json: { answer: response[:data][:answer], success: true }, status: :ok
            else
              render json: { success: false }, status: :internal_server_error
            end
          else
            render json: { success: false }, status: :internal_server_error
          end
        end
      rescue => e
        render json: { success: false, message: "#{e.message}" }, status: :internal_server_error
      end

      def top_questions
        questions = @book.questions.order(ask_count: :desc).limit(10)
        render json: { success: true, data: { top_questions: questions.pluck(:query) } }
      end

      private

      def question_params
        params.require(:question).permit(:query, :book_id)
      end

      def load_book
        @book = Book.find(question_params[:book_id])
        unless @book.present?
          render json: { success: false, message: "Incorrect Book Provided" }, status: :bad_request
        end
      end
    end
  end
end
