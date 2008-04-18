class Post
  include DataMapper::Resource
  include DataMapper::Validate
  
  one_to_many :comments
  
  property :id, Fixnum, :serial => true
  property :slug, String
  property :title, String, :length => 255, :nullable => false
  property :body, DataMapper::Types::Text, :nullable => false
  property :body_html, DataMapper::Types::Text, :nullable => false, :lazy => false
end