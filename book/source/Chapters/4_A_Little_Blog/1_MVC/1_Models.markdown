## Models

(TODO) - rewrite for DM 0.9 almost done, just need to finish it!

### Getting started

Having discussed the functionality we can deduce that we will need the following models, `Post`, `Comment`, `Tag`, `User` and `Image`.

Building a model with Merb and DataMapper requires generating a model, specifying attributes (properties), and running a migration to create the database table and all the properties. Generating a model is similar to Rails, as is running a migration. But unlike Rails and ActiveRecord, Mern and DataMapper use no separate migration files. Instead, properties are defined in the model itself. (Describe the benefit of defining properties in the model? Why is that better than the separate ActiveRecord migrations?)

#### The Model Generator

DataMapper has a model generator just as Rails does:

    merb-gen model post

This will make a post model for you, provided that you have defined an orm and the database golb, in the previous steps.

(Don't mention `rake dm:db:automigrate` at this point because if it is run without properties, the user will get an SQL error.)

You can set the name of the database table in your model if it is called something different with:

    set_table_name 'list_of_posts'
    
This is only necessary if you are using an already existing database.

#### Properties

So DataMapper models differ a bit from ActiveRecord models as previously stated. Defining the database columns is achieved with the `property` method.

app/models/post.rb

    property :title,  String, :lazy => false
    
This is the `title` property of the post model. As we can see, the parameters are the name of the table column followed by the type and finally the options. 

Some of the available options are:
(TODO) - cover more properties

    :public, :protected, :private, :accessor, :reader, :writer,
    :lazy, :default, :nullable, :key, :serial, :field, :size, :length,
    :format, :index, :check, :ordinal, :auto_validation, :validates, :unique,
    :lock, :track, :scale, :precision

    :key          - Set as primary key
    :serial       - auto-incrementing key
    :lazy         - Lazy load the specified property (:lazy => true).
    :default      - Specifies the default value
    :column       - Specifies the table column
    :nullable     - Can the value be null?
    :index        - Creates a database index for the column
    :accessor     - Set method visibility for the property accessors. Affects both
                    reader and writer. Allowable values are :public, :protected, :private.
    :reader       - Like the accessor option but affects only the property reader.
    :writer       - Like the accessor option but affects only the property writer.
    :protected    - Alias for :reader => :public, :writer => :protected
    :private      - Alias for :reader => :public, :writer => :private
    
(TODO) - talk about accessors and overriding them
    
DataMapper supports the following properties:

* TrueClass, Boolean
* String
* Text (limit of 65k characters by default)
* Float
* Fixnum, Integer
* BigDecimal
* DateTime
* Date
* Object (marshalled out during serialization)
* Class (datastore primitive is the same as String. Used for Inheritance)

(TODO) - creating your own custom properties

#### Associations

Like ActiveRecord, DataMapper has associations which define relationships between models.
There is difference in syntax but the underling idea is the same. Continuing with the `Post` model we can see a few of the associations defined:
    
    has n, :comments
    belongs_to :author, :class => 'User', :foreign_key => 'author_id'
    
The `has n` syntax is a very flexible way to define associations and the standard way in DataMapper > 0.9. It can be used to model all of ActiveRecord associations plus more.  The types of associations currently in DataMapper are:
  
     # DataMapper 0.9  | ActiveRecord
     has n             # has_many
     has 1             # has_one
     belongs_to        # belongs_to
     many_to_one       # belongs_to
     has n, :association => :join_table # has_and_belongs_to_many NOTE: not currently support see HABTM section below
     has n, :association => :model      # has_many :association, :through => :model  
     
The `has n` syntax is more powerful than above, since n is the cardinality of the association, it can be an arbitrary range.  Some examples:

    has 0..n #=> will have a MIN of 0 records and a MAX of n
    has 1..n #=> will have a MIN of 1 record and a MAX of n
    has 1..3 #=> will have a MIN of 1 record and a MAX of 3
    
Pretty straight forward. A few things you should note however, you do not need to specify the foreign key as a property if it's defined in the association.

You also don't have to specify a relationship at all if you don't want to, as models can have one way relationships.

##### Polymorphic associations
http://pastie.textmate.org/private/mrvx3qmuagypwukrri9jq
(TODO) -polly assoc (pastie link is broken)

##### Has And Belongs To Many (HABTM)
As of this writing HABTM is not supported in DataMapper associations, but it can be modeled as a `has_many :through` association.  The only difference is that instead of having a simple join table, you will need a join Model.  The example below for `has_many :through` would effectively replace a HABTM relationship to Category.

##### Where is my `has\_many :through`?!
DataMapper > 0.9 now supports has_many :through.  For example, if you have a Post model that has many Categories through the Categorization model you would define these associations:

     class Post
       include DataMapper::Resource

       has n, :categorizations
       has n, :categories => :categorizations
       # or you could use an alternative syntax:
       has n, :categories, :through => :categorizations
       
     end
     
     post = Post.first
     post.categorizations #=> []
     post.categories #=> []
     # to attach a category to a post:
     post.categorizations << Categorization.new(:category => Category.first)
     # or you could just create a Categorization object passing in both category and post:
     Categorization.create(:post => post, :category => Category.first)
    

 
#### Validation

(TODO) - custom validation, and validatable gem
(TODO) - does this user bashing fluff need to be here?
(TODO) - still needs 0.9 love

It’s a known fact that users are stupid. They screw up; it happens. They enter information in the wrong format, leave required fields blank, or even enter in completely horrid data because they’re idiots and that’s what idiots do. I point you at [YouTube](http://www.youtube.com) video comments, [Digg](http://www.digg.com) (as a whole), and [MySpace](http://www.myspace.com) as proof of web users’ collective idiocy.

But, alas, they’re how we make our money online. Thus, we need to guard against user error by validating anything that we need to save out to our persistence layers. Sometimes that means guarding against hack attempts, but most of the time it means guarding against invalid data and accidents.

Both ActiveRecord and DataMapper have a concept called Validations, which is ultimately a set of callbacks which fire right before an object gets saved out to our persistence layer and interrupt things when it detects something awry.  To use them in datamapper, all we have to do is require the gem `dm-validations`

    require 'dm-validations'

    class Post
      include DataMapper::Resource

      property :id, Integer, :serial => true
      property :title, String, :length => 0..255
      property :body, Text
      property :original_uri, String, :length => 0..255
      property :created_at, DateTime
      property :can_be_displayed, Boolean, :default => false

      validates_present :body

    end

How many validations do we have on the content of the post class? To someone
familar with ActiveRecord, the answer is obviously one.  We have a validation
that the body must contain something - that it is present.  In fact DataMapper,
through dm-validations, has set up _four_ validations for us.  When we declare
properties like `:length => 0..255` as well as declaring the maximum length for
the field, it also adds a validation to check that the supplied values will fit
within that field.  So when we validate our model DataMapper will check we ...

* have a `body`, which contains ... something, at least

And also, without us having to type anything, that we ...

* have a `title`, with a length somewhere between 0 and 255 characters
* have an `original_url`, with a length somewhere between 0 and 255 characters.
* have a value for `can_be_displayed` which is `true` or `false` (but not `nil`)

We can test this by calling `valid?` on one of our posts:

    @post = Post.new
    @post.valid?
    => false
    @post.title = "A cool story!"
    @post.body = "It was a dark and stormy ..."
    @post.valid?
    => true


A problem arises when your website has users creating content and content being created automatically from scrapers or some sort of automated background process (be it from RSS feeds, an FTP server or a web service). No idiots are involved in the creation of content when it’s imported into the system and you likely really want that content to appear in your system. This is where Group Validations come in to play.

Group Validations are callbacks which kick-in as a subset, rather than all validations running at once. You might want to make sure that a user enters the title for a blog post in your system, but you don’t really want such a check for when that blog post comes in off of your RSS scraping system. Maybe you’d send those imported blog posts into a holding pen somewhere so that they can be rescued later, rather than preventing their save and never importing them in at all.

With ActiveRecord, if you declare a `validates\_presence\_of` on `:title`, that’s it - game over. The only way to bypass that validation is to `save\_without\_validations` and that skips all of your validations, rather than just this one.

But with DataMapper and it’s use of Validatable, you can check for the validity of an object depending on the circumstance you’re in. Here’s what that blog post model would look like if we wanted to validate blog posts by idiots, but not from our not-so-idiotic scrapper:

If this shit doesn’t work, consider it pseudo-code. If it does work, I’m a badass (quoted! -bj)

    class Post
      include DataMapper::Resource

      property :title, :string, :length => 0..255
      property :body, :text
      property :original_uri, :string, :length => 0..255
      property :created_at, :datetime
      property :can_be_displayed, :boolean, :default => false

      # user creation
      validates_presence_of :title,
        :groups => [:manual_entry, :display]
      validates_presence_of :body,
        :groups => [:manual_entry, :save, :display]

      # automated import
      validates_presence_of :original_uri, :groups => [:import]

      alias_method :__save, :save

      def save(context = :valid_for_save?)
        self.__save if self.send(context)
      end

      before_save do |instance|
        instance.can_be_displayed = true if instance.valid_for_display?
      end
    end
	
Running quickly through my sample here, you’ll spot this odd `:groups => [...]` argument to a few of the validations. These define which group these validations are a part of. Validatable uses these to give us a few dynamic methods like `valid\_for\_display?` and `valid\_for\_manual\_entry?`, which is the mechanism used to check if an instance is valid in one context or another.

Using a model setup like this, we could call `@post.valid\_for\_manual\_entry?` when we need to verify that the idiot’s blog post can be added into our persistence layer safely. By overloading the `save()` method so that you pass in the group of validations to be executed (like `:valid\_for\_manual\_entry` or `:valid\_for\_import`) to use when checking validity, we’ve effectively made it possible to choose which validation callbacks get fired and which don’t when saving out the model. NOTE: As I wrote this, a discussion was occurring in [#datamapper on irc.freenode.net](irc://irc.freenode.net/datamapper) about making `save()` smarter so it respects grouping. Having to overload `save()` may not be needed in the future. As usual, your results may vary.

You’ll notice that I gave `:body` a `validates\_presence\_of` for both the `:manual\_entry` group and the `:save` group. This means that, no matter what, that validation callback will kick in.

Also of note is the `can\_be\_displayed` boolean and the `before\_save` manual callback I defined. Here, I’m helping myself out later on so that it’s easy to pull out valid blog posts that can be displayed without worrying about nil field values and such:

    @posts = Post.all(
      :title.not => nil,
      :slug.not => nil,
      :order => 'created_at desc',
      :limit => 10
    )
	
Becomes…

    @posts = Post.all(
      :can_be_displayed => true,
      :order => 'created_at desc',
      :limit => 10
    )
	
Pretty sexy, no? I can’t off-hand think of a way to get this functionality from ActiveRecord objects without manually mixing in Validatable and then fighting the battle between AR’s validations and Validatable’s validations. (I likely just need to think harder, though….maybe using single-table inheritance and then tacking on different validations for different subclasses…maybe?)

With the proper use of Group Validations, you end up saving yourself a lot of headache and work later on down the line, as well as supporting different scenarios where a post might be valid or might not–all without having to hack-around. How enterprise-y!

##### validates\_true\_for

The second outstanding feature of Validatable that I’m oh-so-in-love with is `validates\_true\_for`. Think of it like overloading `valid?` only capable of the full power of real validations behind it.

Say, for example, you’ve got an Event model that needs to make sure the `end\_date` for the event is greater than the start_date. Wouldn’t want to break the laws of physics, so we’d do something like:

    class Event < ActiveRecord::Base
      def valid?
        start_time < end_time
      end
    end
	
Yup, it’s pretty simple with ActiveRecord. Just toss in our own valid? method and we’re done. With DataMapper, things are a touch more complicated, but overall not brutally difficult, and buy you the full power of Validatable validations:

    class Event
      include DataMapper::Resource

      # properties here

      validates_true_for :start_time, :logic => lambda {
        start_time < end_time
      }
    end
	
So, a couple of things are going on here. First, we’re declaring the check to make sure `start\_time` being less than `end\_time` on the `start\_time` property. We could have easily done it on the `end\_time` property as well (take your pick). Secondly, we’re passing in a block (lambda) to be called when the check occurs. As long as our lambda returns true, we’re golden, the validation passes, and the object can be saved out to the persistence layer.

Say we want to do much more complicated logic, though.

    class Event
      include DataMapper::Resource

      # properties here

      scary_validation = lambda do
        # freakish logic here for particularly complicated
        # validations.
      end

      validates_true_for :start_time, :logic => scary_validation
    end
	
Ruby’s support for closures is so damn-skippy that we can pass blocks of code around, assign them to variables, execute them later, totally forget about them, whatever we want. We don’t need to overload a method or anything.

Plus, we’ve elevated our advanced validation logic into a real Validation which we can then assign to groups, pass around from object to object, what-have-you. Had we just stuck this code in an overloaded .valid? method, we wouldn’t get our spiffy Group Validation stuff as well as a few other things that make Validatable so-very-sexy.

##### In Conclusion

Validations with Validatable (in DataMapper) are that much more powerful than their counter-parts in ActiveRecord, and therefore, you should switch to DataMapper (or Validatable)

#### Callbacks

Callbacks in DataMapper > 0.9 are very powerful.  In any DataMapper::Resource you can set before and after callbacks on any instance/class method.  There are a couple of different ways to define callbacks:

    class Post
      include DataMapper::Resource
      
      property :id, Integer, :serial => true
      property :title, String, :length => 200
      
      # before save call the instance method make_permalink
      before :save, :make_permalink
      
      def make_permalink
        self.title = PermalinkFu.permalink(self.title)
      end
      
      #callbacks can be defined for any method
      after :publish, :send_message
      
      def publish
        # do some publishing here
      end
      
      def send_message
        # email someone here
      end
      
      # defining a callback on a class method, passing in a block to run before its created.
      before_class_method :create do
        # do something before a record is created
      end
      
    end

#### Migrations

There is a rake task to migrate your models, but be warned migrations are currently destructive!

    rake dm:db:auto_migrate    # Automigrates all models
    rake dm:db:autoupgrade     # Perform non destructive automigration

You can also create databases from the Merb console (`merb -i`)

    database.save(Posts) 

This does the same job as the rake task migrating all your models.

    DataMapper.auto_migrate! 

Migrations in the sense of AR migrations, don't exist yet, so you'll have to manually alter your database if you want to retain your data. There are plans however to include migrations in a future version of DataMapper.

### CRUD

#### Creating
To create a new record, just call the method create on a model and pass it your attributes.

    @post = Post.create(:title => 'My first post')
    
Or you can instantiate an object with #new and save it to the repository later:

    @post = Post.new
    @post.title = 'My first post'
    @post.save
    
There is also an AR like method to `find\_or\_create` which attempts to find an object with the attributes provided, and creates the object if it cannot find it:

    @post = Post.first_or_create(:title => 'My first post')
    
There are a couple of different ways to set attributes on a model:

    @post.title = 'My first post'
    @post.attributes = {:title => 'My first post'}
    @post.attribute_set(:title, 'My first post')
    
Find out if an attribute has been changed (aka is dirty):

    @post = Post.first
    @post.dirty?
    => false
    @post.attribute_dirty?(:title)
    => false
    @post.title = 'Changing the title'
    @post.dirty?
    => true
    @post.attribute_dirty?(:title)
    => true
    @post.dirty_attributes
    => Set: {#<Property:Post:title>}

    
#### Reading (aka finding)

The syntax for retrieving data from the database is clean an simple. As you can see with the following examples.

Finding a post with one as its primary key is done with the following:

    # will raise a DataMapper::ObjectNotFoundError if not found
    # use #get to just return nil if not record is found
    Post.get!(1)
 
To get an array of all the records for the post model:

    Post.all

To get the first post, with the condition author = 'Matt':

    Post.first(:author => 'Matt')

When retrieving data the following parameters can be used:

    #   Posts.all :order => 'created_at desc'              # => ORDER BY created_at desc
    #   Posts.all :limit => 10                             # => LIMIT 10
    #   Posts.all :offset => 100                           # => OFFSET 100
    #   Posts.all :includes => [:comments]

If the parameters are not found in these conditions it is assumed to be an attribute of the object.

You can also use symbol operators with the find to further specify a condition, for example:

    Posts.all :title.like => '%welcome%', :created_at.lt => Time.now

This would return all the posts, where the tile was like 'welcome' and was created in the past.

Here is a list of the valid operators:

* gt    - greater than
* lt    - less than
* gte   - greater than or equal
* lte   - less than or equal
* not   - not equal
* like  - like
* in    - will be used automatically when an array is passed in as an argument
    
TODO: no more find_by_sql, but im sure there is another way to just execute SQL.

##### Aggregates

DataMapper by default does not provide aggregator methods, but dm-aggregates in dm-more does. After adding `dependency "dm-aggregates"` to your merb init.rb file, your resource model will have aggregator methods including #count, #min, #max, #avg, and #sum.  You can pass conditions to any of these aggregator methods the same as Resource.first or Resource.all

    Post.count :title.like => "%hello world%"
    
    # you can also do a count on an association:
    @post.comments.count
    
    Post.avg(:reads_count)
    
    Post.sum(:comments_count)
    
    
##### Each

Each works like like expected iterating over a number of rows and you can pass a block to it. The difference between `Comments.all.each` and `Comments.each` is that instead of retrieving all the rows at once, each works in batches instantiating a few objects at a time and executing the block on them (so is less resource intensive). Each is similar to a finder as it can also take options:

    Comments.each(:date.lt => Date.today - 20).each do |c|
        c.destroy!
    end

#### Updating

Updating attributes has a similar syntax to ARs `update_attributes`:

    @post.update_attributes(:title => 'Opps the title has changed!')
    
You can also just set attributes and then save:

    @post = Post.first
    @post.title = 'New Title!'
    @post.save


#### Destroying

You can destroy database records with the method destroy!, this work much like AR.
 
    bad_comment = Comment.first
    bad_comment.destroy
    
