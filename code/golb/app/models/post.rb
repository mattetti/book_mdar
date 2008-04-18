class Post
  include DataMapper::Resource
  # include DataMapper::Validate
  
  # property :slug, String
  property :title, String, :nullable => false, :length => 255
  # property :body, DataMapper::Types::Text, :nullable => false
  # property :body_html, DataMapper::Types::Text, :nullable => false, :lazy => false
end