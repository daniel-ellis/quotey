module Quotey_helper
  
  require_relative 'mongo'
  
  def random_quote
    if params['not_by']
      random_quote_not_by params['not_by']
    else
      Quote.all_in.to_a.sample      
    end
  end
  
  def random_quote_not_by name
    name_split = name.split(' ')
    if name_split[1]
      return Quote.excludes(author_first: name_split[0], author_last: name_split[1]).to_a.sample
    else
      return Quote.excludes(author_first: name_split[0], author_last: name_split[1]).to_a.sample      
    end
  end
  
  def all_quotes
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