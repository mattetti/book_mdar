## A little blog

In the examples we'll be developing a small blogging application. It's a good idea to grab the source code from [http://github.com/deimos1986/book_mdar/tree/master/code](http://github.com/deimos1986/book_mdar/tree/master/code), so you can follow along with the examples.

First of all let's define some of the functionality we would expect from any blogging application. 

* Publishing posts
* Leaving comments
* Sending email notifications
* Attaching images
* Authentication

Lets get started with our application:

    merb-gen golb

We're going to use the Linguistics gem later on, you can install it with:
    
    gem install Linguistics

Set up the configuration files as before:

config/init.rb

    use_orm :dm_core

    use_test :rspec

	dependencies "Linguistics", "dm-validations"

    
Now add a config/database.yml file with the following:

	---
	# Edit this file:
	development: &defaults
	    # These are the settings for repository :default
	    adapter:  mysql
	    database: golb
	    host: localhost
	    username: root
	    password:
	    socket: /opt/local/var/run/mysql5/mysqld.sock
	    log_stream: STDOUT
	    log_level: 0

	test: &defaults
	    # These are the settings for repository :default
	    database: golb_test
      
Now we're ready to rock and roll ...