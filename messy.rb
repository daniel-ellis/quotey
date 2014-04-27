# Messy code tips
# Add the quotes to a file and refactor this shite e.g. get_elements shouldnt need to quote.
require 'sinatra'
require 'json'
$quotes = {}

def load_file
  $quotes = JSON.parse(File.new('quotes.json').read)
end

def save_file
  `cat quotes.json >> backup.json`
  File.open('quotes.json', 'w') { |file| file.write($quotes.to_json)}
end

def output_json element
  response.headers['Content-Type'] = 'application/json'
  element.to_json
end

def get_element id
  $quotes.each do |quote|
    return quote if quote['id'] == id
  end
  nil
end

def params_contain? params, array
  array.each do |expected|
    return false unless params.has_key? expected
  end
  true
end

def add_quote id, quote, author
  $quotes.push({ 'id' => id, 'quote' => quote, 'author' => author })
end

get '/reload_file' do
  load_file
  'd'
end
get '/random.json' do
  random_quote = $quotes.sample
  output_json random_quote
end

get '/random' do
  random_quote = $quotes.sample
  "#{random_quote['quote']}\n\t - #{random_quote['author']}\n"
end

get '/all.json' do
  output_json $quotes
end

post '/' do
  if params_contain?(params, %w(author quote id)) && !(get_element(params['id'].to_i))
    add_quote(params['id'].to_i, params['quote'], params['author'])
    save_file
    'done'
  else
    400
  end
end

delete '/' do
  id_to_del = params['id']
  if id_to_del && !!(get_element(params['id'].to_i))
    $quotes.delete get_element id_to_del.to_i
    save_file
    'deleted'
   else    
     400
  end
end

get '/*' do
  [404, 'We couldn't find that, sorry!']
end

# Load the file when the server starts
configure do
  set :port, ENV['PORT']
  load_file
end

