module Shitty
  
  require_relative 'mongo'
  
  def random_quote
    # TODO - return a random quote
    Quote.all_in.to_a.sample
  end
  
  def all_quotes
    # TODO - return all of the quotes
    Quote.all_in
  end
  
  def add_quote quote, author
    split_name = author.split(' ')
    first = split_name[0]
    last = split_name[1] if split_name.count > 1
    Quote.create( 
      random: rand,
      quote: quote,
      author_first: first,
      author_last: last
    )
  end
  
  def del_quote id
    get_quote(id).delete
  end
  
  def clean_json quote
    { 'id' => quote['_id'],
      'quote' => quote['quote'],
      'first' => quote['author_first'],
      'last' => quote['author_last']
    }
  end
  
  def output_json element
    response.headers['Content-Type'] = 'application/json'
    element.to_json
  end

  def get_quote id
    Quote.where(_id: id).first # should only be one
  end

  def params_contain? params, array
    array.each do |expected|
      return false unless params.has_key? expected
    end
    true
  end
end