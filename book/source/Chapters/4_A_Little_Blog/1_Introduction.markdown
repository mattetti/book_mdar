## A little blog

In the examples we'll be developing a small blogging application. It's a good idea to grab the source code from 
(TODO) -location, so you can follow along with the examples.

First of all let's define some of the functionality we would expect from any blogging application. 

* Publishing posts
* Leaving comments
* Sending email notifications
* Attaching images
* Authentication

Lets get started with out application:

    merb-gen simple_blog

We're going to use the Linguistics gem later on, you can install it with:
    
    gem install Linguistics

Set up the configuration files as before:

config/init.rb

    use_orm :data_mapper

    use_test :rspec
    
    Merb::BootLoader.before_app_loads do
      dependencies "RedCloth", "merb_helpers"
      dependencies 'linguistics'
    end
    
Now add a config/database.yml file with the following:

    ---
    :development: &defaults
      :adapter: mysql
      :database: simple_blog
      :username: root
      :password: 
      :host: localhost

    :test:
      <<: *defaults
      :database: simple_blog_test

    :production:
      <<: *defaults
      :database: simple_blog_production
      
Now we're ready to rock and roll ...