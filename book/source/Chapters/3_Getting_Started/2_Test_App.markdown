## Creating an App

One of the best ways to become familiar with a framework is to jump in and get 
your hands dirty.  So now that we've got everything installed, it's time to roll 
up your sleeves and create a test Merb application. 

Merb-more comes with a `gem` called `merb-gen`, this gives you a command line 
tool by the same name which is used for all of your generator needs. You can 
think of it as `script/generate`. Running `merb-gen` from the command line with 
no arguments will show you all of the generators that are available.

Merb follows the same naming convention for projects as rails, so 
'my\_test\_app' and 'Test2' are valid names but 'T 3' is not (they need to be 
valid SQL table names).

    merb-gen app test
    
This will generate an empty Merb app, so lets go in and take a look. You'll 
notice that the directory structure is similar to Rails, with a few differences.

    # expected output
    RubiGen::Scripts::Generate
      create  log
      create  gems
      create  app
      create  app/controllers
      create  app/helpers
      create  app/views
      create  app/views/exceptions
      create  app/views/layout
      create  autotest
      create  config
      create  config/environments
      create  public
      create  public/images
      create  public/stylesheets
      create  spec
      create  app/controllers/application.rb
      create  app/controllers/exceptions.rb
      create  app/helpers/global_helpers.rb
      create  app/views/exceptions/internal_server_error.html.erb
      create  app/views/exceptions/not_acceptable.html.erb
      create  app/views/exceptions/not_found.html.erb
      create  app/views/layout/application.html.erb
      create  autotest/discover.rb
      create  autotest/merb.rb
      create  autotest/merb_rspec.rb
      create  config/rack.rb
      create  config/router.rb
      create  config/init.rb
      create  config/environments/development.rb
      create  config/environments/production.rb
      create  config/environments/rake.rb
      create  config/environments/test.rb
      create  public/merb.fcgi
      create  public/images/merb.jpg
      create  public/stylesheets/master.css
      create  spec/spec.opts
      create  spec/spec_helper.rb
      create  /Rakefile


### Configuring Merb

Before we get the server running, you'll need to edit the `init.rb` file and 
un-comment the following line (this is only necessary if you need to connect 
to a database, which we do in our case):

`config/init.rb`

    use_orm :datamapper
    
Typing `merb` now in your command line will start the server.

    Loaded DEVELOPMENT Environment...
    No database.yml file found in /Users/work/merb/example_one/config, assuming database connection(s) established in the environment file in /Users/work/merb/example_one/config/environments
    loading gem 'merb_datamapper' ...
    Compiling routes...
    Using 'share-nothing' cookie sessions (4kb limit per client)
    Using Mongrel adapter

As you can see, however, we did not yet configure the database. Let's create the
database.yml file that merb is looking for:

`config/database.yml`

    # This is a sample database file for the DataMapper ORM
    development:
       adapter: mysql
       database: test
       username: root
       password: 
       host: localhost
	   socket: /tmp/mysql.sock

Don't forget to specify your socket, if you do not know it's location, you 
can find it by typing:

    mysql_config --socket

Starting Merb again shows that everything is running okay.

The following command will give you access to the Merb interactive console:

    merb -i

You'll notice Merb runs on port 4000, but this can be changed with flag 
`-p [port number]`. More options can be found by typing:

    merb --help
    
You can even run Merb with any application server that supports rack 
(thin, evented_mongrel, fcgi, mongrel, and webrick):

    merb -a thin

If you see a 500 error with the following error message when trying to navigate
to localhost:4000 in your browser:
    
    undefined method `match' for Merb::Router:Class - (NoMethodError)

This means Merb has been started outside of your applications root directory.
