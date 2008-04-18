## Models

(TODO) - rewrite for DM 0.9, and make this section clearer

### Getting started

Having discussed the functionality we can deduce that we will need the following models, `Post`, `Comment`, `Tag`, `User` and `Image`.

DataMapper has a model generator just as rails does:

    merb-gen model post

This will make a post model for you, provided that you have defined an orm and the database golb, in the previous steps.

When you run `rake dm:db:auto_migrate`, it will create the database table and all the properties, but take care this is a destructive method!

You can set the name of the database table in your model if it is called something different with:

    set_table_name 'list_of_posts'
    
This is only necessary if you are using an already existing database.

#### Properties

So DataMapper models differ a bit from ActiveRecord models as previously stated. Defining the database columns is achieved with the `property` method.

app/models/post.rb

    property :title,      :string,    :lazy => false
    
This is the `title` property of the post model. As we can see, the parameters are the name of the table column followed by the type and finally the options. 

Some of the available options are:

    :lazy         - Lazy load the specified property (:lazy => true).
    :default      - Specifies the default value
    :column       - Specifies the table column
    :nullable     - Can the value be null?
    :key          - Set as primary key
    :index        - Creates a database index for the column
    :accessor     - Set method visibility for the property accessors. Affects both
                    reader and writer. Allowable values are :public, :protected, :private.
    :reader       - Like the accessor option but affects only the property reader.
    :writer       - Like the accessor option but affects only the property writer.
    :protected    - Alias for :reader => :public, :writer => :protected
    :private      - Alias for :reader => :public, :writer => :private


#### Associations

Like ActiveRecord, DataMapper has associations which define relationships between models. Continuing with the `Post` model we can see a few of the associations defined:
    
    has_many :comments
    belongs_to :author, :class => 'User', :foreign_key => 'author_id'
    
You also can have the associations, `has\_one` and `has\_and\_belongs\_to\_many` (where you can specify the `:join_table`).
    
Pretty straight forward. A few things you should note however, you do not need to specify the foreign key as a property if it's defined in the association, and currently `has\_one` is implemented as `has\_many` (so it returns an array with one object instead of just the object itself, but this is will likely change!).

You also don't have to specify a relationship at all if you don't want to, as models can have one way relationships.

##### Polymorphic associations
http://pastie.textmate.org/private/mrvx3qmuagypwukrri9jq
(TODO) -polly assoc (pastie link is broken)

##### Where is my `has\_many :through`?!
`has\_many :through` is in the pipes, but it is not currently in DM. You can however mimic that behaviour by specifying the tables to join on, in the join model.

    # has_many :categories, :through => :categorizations
    has_many :categorizations

    has_and_belongs_to_many :categories,
      :join_table => "categorizations",
      :left_foreign_key => "post_id",
      :right_foreign_key => "category_id",
      :class => "Category"
    
You still have access to `.categorizations` and you now have access to `.categories` as well… plus no new tables or nothing. If `categorizations` had, say, a `score` column on it which stores how strongly your `categorization` process thinks this post belongs to this category, you could tack on `:order => 'score desc'` to the `has\_and\_belongs\_to\_many` just fine.
 
#### Validation

(TODO) - custom validation, and validatable gem
It’s a known fact that users are stupid. They screw up; it happens. They enter information in the wrong format, leave required fields blank, or even enter in completely horrid data because they’re idiots and that’s what idiots do. I point you at [YouTube](http://www.youtube.com) video comments, [Digg](http://www.digg.com) (as a whole), and [MySpace](http://www.myspace.com) as proof of web users’ collective idiocy.

But, alas, they’re how we make our money online. Thus, we need to guard against user error by validating anything that we need to save out to our persistence layers. Sometimes that means guarding against hack attempts, but most of the time it means guarding against invalid data and accidents.

Both ActiveRecord and DataMapper have a concept called Validations, which is ultimately a set of callbacks which fire right before an object gets saved out to our persistence layer and interrupt things when it detects something awry.

A problem arises when your website has users creating content and content being created automatically from scrapers or some sort of automated background process (be it from RSS feeds, an FTP server or a web service). No idiots are involved in the creation of content when it’s imported into the system and you likely really want that content to appear in your system. This is where Group Validations come in to play.

Group Validations are callbacks which kick-in as a subset, rather than all validations running at once. You might want to make sure that a user enters the title for a blog post in your system, but you don’t really want such a check for when that blog post comes in off of your RSS scraping system. Maybe you’d send those imported blog posts into a holding pen somewhere so that they can be rescued later, rather than preventing their save and never importing them in at all.

With ActiveRecord, if you declare a `validates\_presence\_of` on `:title`, that’s it - game over. The only way to bypass that validation is to `save\_without\_validations` and that skips all of your validations, rather than just this one.

But with DataMapper and it’s use of Validatable, you can check for the validity of an object depending on the circumstance you’re in. Here’s what that blog post model would look like if we wanted to validate blog posts by idiots, but not from our not-so-idiotic scrapper:

If this shit doesn’t work, consider it pseudo-code. If it does work, I’m a badass (quoted! -bj)

    class Post
      include DataMapper::Persistence

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
      include DataMapper::Persistence

      # properties here

      validates_true_for :start_time, :logic => lambda {
        start_time < end_time
      }
    end
	
So, a couple of things are going on here. First, we’re declaring the check to make sure `start\_time` being less than `end\_time` on the `start\_time` property. We could have easily done it on the `end\_time` property as well (take your pick). Secondly, we’re passing in a block (lambda) to be called when the check occurs. As long as our lambda returns true, we’re golden, the validation passes, and the object can be saved out to the persistence layer.

Say we want to do much more complicated logic, though.

    class Event
      include DataMapper::Persistence

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

(TODO) list of available call backs

#### Migrations

There is a rake task to migrate your models, but be warned migrations are currently destructive!

    rake dm:auto_migrate    # Automigrates all models

You can also create databases from the Merb console (`merb -i`)

    database.save(Posts) 

This does the same job as the rake task migrating all your models.

    DataMapper::Persistence.auto_migrate! 

Migrations in the sense of AR migrations, don't exist yet, so you'll have to manually alter your database if you want to retain your data. There are plans however to include migrations in a future version of DataMapper.

### CRUD

#### Creating
To create a new record, just call the method new on a model and pass it your attributes.

    @post = Post.new(:title => 'My first post')
    
There is also an AR like method to `find\_or\_create` which attempts to find an object with the attributes provided, and creates the object if it cannot find it.

There is another way to create an object, which is to save it after the attributes have been set like this:
   
    @post = Post.new
    @post.attributes = {:name => 'Hi!',:body => 'This is just awesome!'}
    @post.save
    
#### Reading (aka finding)

The syntax for retrieving data from the database is clean an simple. As you can see with the following examples.

Finding a post with one as its primary key is done with the following:

    Post[1]
 
To get an array of all the records for the post model:

    Post.all

*NOTE*: you can also do Post.find(:all), like the AR syntax but this is just a synonym for Post.all

To get the first post, with the condition author = 'Matt':

    Post.first(:author => 'Matt')

When retrieving data the following parameters can be used:

    #   Posts.all :order => 'created_at desc'              # => ORDER BY created_at desc
    #   Posts.all :limit => 10                             # => LIMIT 10
    #   Posts.all :offset => 100                           # => OFFSET 100
    #   Posts.all :include => [:comments]

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
    
If you require a custom find, you can use SQL with the method, `find\_by\_sql`. This will return an array of Structs (which are read-only) with the result of the query. 

##### Count

DM provides a count method to count the number of records of a model, you can also pass search conditions to count:

    comment_count = Post[1].comments.count
    
##### Each

Each works like like expected iterating over a number of rows and you can pass a block to it. The difference between `Comments.all.each` and `Comments.each` is that instead of retrieving all the rows at once, each works in batches instantiating a few objects at a time and executing the block on them (so is less resource intensive). Each is similar to a finder as it can also take options:

    Comments.each(:date.lt => Date.today - 20).each do |c|
        c.destroy!
    end

#### Updating

Updating attributes has a similar syntax to ARs `update_attributes`:

    Post.update_attributes(:title => 'Opps the title has changed!')
    Post.save

Post will only update the attributes which it persists and have changed, so changing virtual attributes will require marking the object as dirty to force a save.

#### Destroying

You can destroy database records with the method destroy!, this work much like AR.
 
    bad_comment = Comment[6]
    bad_comment.destroy!
    
Should you want to delete all the records of a model, you can do the following:

    Comment.delete_all
