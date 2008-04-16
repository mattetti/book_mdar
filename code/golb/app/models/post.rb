class Post
  include DataMapper::Resource
  property :name, String
  property :body, DataMapper::Types::Text
  property :body_html, DataMapper::Types::Text, :lazy => false
  property :author_id, Fixnum
  property :display_on, DateTime
  property :created_on, DateTime  
  
end