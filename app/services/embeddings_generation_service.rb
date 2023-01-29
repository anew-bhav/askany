class EmbeddingsGenerationService
  def initialize(book)
    @book = book
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_KEY"])
  end

  def call
    reader = PDF::Reader.new(@book.file.download)

    page_data = JSON.parse(@book.embeddings || "[]")

    reader.pages.each do |page|
      if page_data.size > 0 && page.number <= page_data.size
        next
      end
      data = {}
      content = clean_page(page.text)
      data[:title] = "Page #{page.number}"
      data[:content] = content
      embeddings, token_count = get_page_embeddings(content)
      data[:embeddings] = embeddings
      data[:token_count] = token_count
      page_data.push(data)
    end
    { success: true, data: page_data.to_json }
  rescue => e
    { success: false, error: e.message, data: page_data.to_json }
  end

  private

  def clean_page(text)
    text.gsub(/ +/, " ")
      .gsub(/\n+/, " ")
  end

  def get_page_embeddings(text)
    sleep(1)
    response = @client.embeddings(parameters: { model: "text-embedding-ada-002", input: text })
    if response.fetch("data", []).size > 0
      [response["data"].first["embedding"], response["usage"]["prompt_tokens"]]
    else
      raise "Something went wrong while requesting embeddings from OpenAI"
    end
  end
end
