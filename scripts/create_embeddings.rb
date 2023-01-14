require 'pdf-reader'
require 'pycall/import'
include PyCall::Import
require 'ruby/openai'
require 'csv'
require 'debug'

file_name = 'book'
file_extension = '.pdf'

file_path = "./scripts/#{file_name}#{file_extension}"

reader = PDF::Reader.new(File.open(file_path))

page_data = []
embedding_data = []

PyCall.pyfrom('transformers', import: "GPT2TokenizerFast")
tokenizer = PyCall::GPT2TokenizerFast.from_pretrained('gpt2')

client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_KEY'])

def clean_page(text)
  text.gsub(/ +/, " ")
  .gsub(/\n+/, " ")
  .gsub(/http\:\/\/www.mudmap.com\/1984\/animalfarm.htm/, '')
  .gsub(/\(\d+ of 71\)/, '')
  .gsub('Animal Farm by George Orwell','')
  .gsub('ANIMAL FARM  by George Orwell', '')
  .gsub(/\[.*\]/, '').strip
end

def count_tokens(tokenizer, text)
  encodings = tokenizer.encode(text)
  PyCall.len(encodings)
end

def get_embeddings(client, text)
  sleep(1)
  response = client.embeddings(parameters: {model: 'text-search-curie-doc-001', input: text})
  response['data'].first['embedding']
end

reader.pages.each do |page|
  data = {}
  data[:title] = "Page #{page.number}"
  data[:content] = clean_page(page.text)
  data[:token_count] = count_tokens(tokenizer, clean_page(page.text))
  page_data.push(data)
end

section_headers = ['title', 'content', 'tokens']
CSV.open("#{file_name}_sections.csv", 'w') do |csv|
  csv << section_headers
  page_data.each do |data|
    csv << [data[:title], data[:content], data[:token_count]]
  end
end

embedding_headers = ['title'] + (0..4095).to_a
CSV.open("#{file_name}_embeddings.csv", 'w') do |csv|
  csv << embedding_headers
  page_data.each do |data|
    embeddings = get_embeddings(client, data[:content])
    csv << [data[:title]] + embeddings
  end
end
