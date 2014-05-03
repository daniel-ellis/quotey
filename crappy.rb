require 'mongoid'

include Mongo
class Quote
  include Mongoid::Document
  field :quote, type: String
  field :random, type: Float
  field :author_first
  field :author_last
end

