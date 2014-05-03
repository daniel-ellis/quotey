# Messy code tips

require 'sinatra'
require 'json'
require_relative 'crappy'

include Shitty

get '/random.json' do
  output_json clean_json random_quote
end

get '/random' do
  quote = random_quote
  "#{quote['quote']}\n\t - #{quote['author_first']} #{quote['author_last']}\n"
end

get '/all.json' do
  all = []
  all_quotes.each {|quote| all.push clean_json quote }
  output_json all
end

get '/test' do
  e = get_quote '5364b6541baf6a32a9000001'
  "#{e['quote']} + #{e['_id']}"
end

post '/' do
  if params_contain?(params, %w(author quote))
    add_quote(params['quote'], params['author'])
    'done'
  else
    400
  end
end

delete '/' do
  id_to_del = params['id']
  if id_to_del && !!(get_quote(id_to_del))
    del_quote(id_to_del)
    'deleted' unless get_quote(id_to_del)
   else    
     [400, 'Id missing or not found']
  end
end

get '/*' do
  [404, 'We couldn\'t find that, sorry!']
end

# Load the file when the server starts
configure do
  set :port, ENV['PORT']
  Mongoid.load!("mongoid.yml")
end

