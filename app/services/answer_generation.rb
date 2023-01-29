class AnswerGeneration
  COMPLETIONS_MODEL = "text-davinci-003"
  QUERY_EMBEDDINGS_MODEL = "text-embedding-ada-002"
  MAX_SECTION_LEN = 500
  SEPERATOR = "\n* "

  COMPLETIONS_API_PARAMS = {
    "temperature": 0.0,
    "max_tokens": 150,
    "model": COMPLETIONS_MODEL,
  }

  def initialize(query, book)
    @query = query
    @book = book
  end

  def call
    initialize_openai_client
    read_embeddings_from_book
    filter_relevant_sections
    construct_prompt

    response = @openai_client.completions(
      parameters: {
        prompt: @prompt,
      }.merge(COMPLETIONS_API_PARAMS),
    )
    case response.code
    when 200
      { success: true, data: { answer: response["choices"][0]["text"], context: @relevant_sections.join(' ') } }
    else
      { success: false }
    end
  rescue => e
      { success: false, error: "Something wrong with OpenAI servers" }
  end

  private

  def initialize_openai_client
    @openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_KEY"])
  end

  def filter_relevant_sections
    relevant_sections_len = 0
    @relevant_sections = []

    sections_ordered_by_query_similarity.each do |_, index|
      section_data = @embeddings.filter{|data| data["title"] == index}.first
      relevant_sections_len += section_data["token_count"].to_i + SEPERATOR.size
      if relevant_sections_len > MAX_SECTION_LEN
        space_left = MAX_SECTION_LEN - relevant_sections_len - SEPERATOR.size
        @relevant_sections << SEPERATOR + section_data["content"][...space_left]
        break
      end
      @relevant_sections << SEPERATOR + section_data["content"]
    end
  end

  def sections_ordered_by_query_similarity
    query_embeddings = get_query_embeddings(@query)
    @embeddings.map do |page_data|
      [vector_similarity(query_embeddings, page_data["embeddings"]), page_data["title"]]
    end.sort_by { |similarity, _| similarity }.reverse
  end

  def read_embeddings_from_book
    file_raw_data = @book.embeddings
    @embeddings = JSON.parse(file_raw_data)
  end

  def get_query_embeddings(text)
    response = @openai_client.embeddings(parameters: { model: QUERY_EMBEDDINGS_MODEL, input: text })
    response["data"].first["embedding"]
  end

  def vector_similarity(a, b)
    ::Vector[*a.map(&:to_f)].inner_product(::Vector[*b.map(&:to_f)])
  end

  def construct_prompt
    @prompt = @book.prompt.gsub(/{{context}}/, @relevant_sections.join(' ')).gsub(/{{query}}/, @query)
  end
end
