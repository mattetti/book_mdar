class Post
  include DataMapper::Resource

  property :id, Integer, :serial => true
  property :title, String, :length => 0..255, :auto_validation => false
  property :body, Text
  property :original_uri, String, :length => 0..255, :auto_validation => false
  property :created_at, DateTime
  property :can_be_displayed, Boolean, :default => false
  
  # user creation
  validates_present :title, :when => [:default, :display]
  validates_present :body, :when => [:default, :display, :import]
  
  # automated import
  validates_length :original_uri, :in => 0..255, :when => :import

  # a callback to set can_be_displayed appropriately (more on these later)
  before :save do
    self.can_be_displayed = true if self.valid? :display
  end
   
  # before save call the instance method make_permalink
  before :save, :make_permalink

  def make_permalink
   # self.title = PermalinkFu.permalink(self.title)
  end
   
end
