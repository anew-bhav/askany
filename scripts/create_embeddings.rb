require "pdf-reader"
require "ruby/openai"
require "debug"
require "json"

file_name = "book"
file_extension = ".pdf"

file_path = "./scripts/#{file_name}#{file_extension}"

reader = PDF::Reader.new(File.open(file_path))

page_data = []

client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_KEY"])

def clean_page(text)
  text.gsub(/ +/, " ")
    .gsub(/\n+/, " ")
    .gsub(/http\:\/\/www.mudmap.com\/1984\/animalfarm.htm/, "")
    .gsub(/\(\d+ of 71\)/, "")
    .gsub("Animal Farm by George Orwell", "")
    .gsub("ANIMAL FARM  by George Orwell", "")
    .gsub(/\[.*\]/, "").strip
end

def get_embeddings(client, text)
  sleep(1)
  response = client.embeddings(parameters: { model: "text-embedding-ada-002", input: text })
  [response["data"].first["embedding"], response["usage"]["prompt_tokens"]]
end

reader.pages.each do |page|
  data = {}
  content = clean_page(page.text)
  data[:title] = "Page #{page.number}"
  data[:content] = content
  embeddings, token_count = get_embeddings(client, content)
  data[:embeddings] = embeddings
  data[:token_count] = token_count
  page_data.push(data)
rescue => e
  binding.break
end

File.open('./book_data.json', 'w+') do |f|
  f.write(page_data.to_json)
end