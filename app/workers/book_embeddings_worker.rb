class BookEmbeddingsWorker
  include Sidekiq::Job

  def perform(book_id)
    book = Book.find(book_id)

    response = EmbeddingsGenerationService.new(book).call
    book.embeddings = response[:data]
    book.save
    unless response[:success]
      raise response[:error]
    end
  end
end