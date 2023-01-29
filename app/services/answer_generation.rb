class AnswerGeneration
  COMPLETIONS_MODEL = "text-davinci-003"
  QUERY_EMBEDDINGS_MODEL = "text-embedding-ada-002"
  MAX_SECTION_LEN = 1000
  SEPERATOR = "\n* "

  COMPLETIONS_API_PARAMS = {
    "temperature": 0.3,
    "max_tokens": 150,
    "model": COMPLETIONS_MODEL,
  }

  def initialize(query, embeddings_file_path:)
    @query = query
    @embeddings_file_path = embeddings_file_path
  end

  def call
    initialize_openai_client
    read_embeddings_file(@embeddings_file_path)
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

  def read_embeddings_file(file_path)
    file_raw_data = File.read(file_path)
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
    @prompt = <<-PROMPT
      George Orwell is a well known writter. He is the author of Animal Farm.
      These are a few questions about the theme of the book.
      Please keep your answers to five sentences maximum, and speak complete sentences. Stop speaking once your point is made.

      Context that may be useful, pull from Animal Farm:
      #{@relevant_sections.join(" ")}

      Q: What is the main theme of Animal Farm?
      A: The main theme of Animal Farm is the dangers of totalitarianism and the betrayal of revolutionary ideals.

      Q: Who is the protagonist in the book?
      A: The animals, particularly the more intelligent ones such as the pigs, are the protagonists in the book.

      Q: Who are the antagonists in the book?
      A: The pigs, specifically Napoleon and Snowball, are the antagonists in the book as they slowly assume more power and betray the other animals.

      Q: What is the significance of the pigs in the book?
      A: The pigs in the book represent the ruling elite and their gradual assumption of power and manipulation of the other animals allegorically depicts the rise of Stalin and the Communist Party in the Soviet Union.

      Q: What historical event does the book allegorically depict?
      A: The book allegorically depicts the Russian Revolution of 1917 and the subsequent rise of Stalin's dictatorship.

      Q: What is the significance of the character Napoleon in the book?
      A: Napoleon represents Joseph Stalin, the leader of the Soviet Union, who consolidates power through manipulation and betrayal of his fellow revolutionaries.

      Q: What is the significance of the character Snowball in the book?
      A: Snowball represents Leon Trotsky, a rival of Stalin's in the Communist Party, who is eventually exiled.

      Q: What is the significance of the character Boxer in the book?
      A: Boxer represents the working class and their blind loyalty to the party, despite being exploited and mistreated.

      Q: What is the significance of the character Old Major in the book?
      A: Old Major represents Karl Marx, the father of Communist theory, whose ideas are corrupted and twisted by the pigs.

      Q: What is the significance of the commandment "All animals are equal" in the book?
      A: The commandment "All animals are equal" represents the ideals of the revolution, which are gradually eroded and replaced with the pigs' dictatorial rule.

      Q: #{@query}
      A:
    PROMPT
  end
end
