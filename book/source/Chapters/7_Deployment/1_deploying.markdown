## Deploying a Merb Application

> "Yes, Rails scales just like everything else scale." - Ezra Zygmuntowicz

The most satisfying experience of building a web application is having others use it.  Implementing a robust deployment plan is essential to ensure each release of your project goes off with out a hitch.  

### The Pieces

#### Subversion

Version control is an essential piece of any software development cycle.  There are several options available, including CVS, Git, Subversion, and many more.  This guide assumes you have either a Subversion or Git repo that holds your application.  

#### Nginx

A proxy is required to handle incoming HTTP requests.  Here there are several options including Apache, Lighttpd, Swiftiply, and many more.  A favorite in the community for performance and simplicity has become Nginx, which we'll use for this example.  Developed in Russia by Igor Sysoev, the goal of Nginx is to provide a lightweight, high performance web server.

#### Capistrano

Merb deployment's base lies with Capistrano.  Originally developed to ease the process of pushing Rails applications into production, it has been improved upon to more generally provide automating tasks via SSH on remove servers.  It can be used for software installation, application deployment, configuration management, and much more.

#### Mongrel

For our merb instances, there are a variety of Ruby web servers.  The de facto standard has been Mongrel, which has also spawned improved stacks such as Thin and Swiftiply.  It is extremely easy to change, so examples for all 3 will be provided.

## Preparing Your Production Server

### Nginx

The stable version of Nginx at the time of writing is 0.5.35 with the latest development of 0.6.29.  There is also a branch that supports a newer balancer for handing out requests.  For this example we'll compile the latest development version.

    ./configure --prefix=/usr/local --with-http_ssl_module
    
Create a configuration file, this example has been maintained by Ezra and is availble at http://brainspl.at/nginx.conf.txt

    # user and group to run as
    user  ez ez;

    # number of nginx workers
    worker_processes  6;

    # pid of nginx master process
    pid /var/run/nginx.pid;

    # Number of worker connections. 1024 is a good default
    events {
      worker_connections 1024;
    }

    # start the http module where we config http access.
    http {
      # pull in mime-types. You can break out your config 
      # into as many include's as you want to make it cleaner
      include /etc/nginx/mime.types;

      # set a default type for the rare situation that
      # nothing matches from the mimie-type include
      default_type  application/octet-stream;

      # configure log format
      log_format main '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status  $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

      # main access log
      access_log  /var/log/nginx_access.log  main;

      # main error log
      error_log  /var/log/nginx_error.log debug;

      # no sendfile on OSX
      sendfile on;

      # These are good default values.
      tcp_nopush        on;
      tcp_nodelay       off;
      # output compression saves bandwidth 
      gzip            on;
      gzip_http_version 1.0;
      gzip_comp_level 2;
      gzip_proxied any;
      gzip_types      text/plain text/html text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;


      # this is where you define your mongrel clusters. 
      # you need one of these blocks for each cluster
      # and each one needs its own name to refer to it later.
      upstream mongrel {
        server 127.0.0.1:4000;
        server 127.0.0.1:4001;
        server 127.0.0.1:4002;
      }

      # the server directive is nginx's virtual host directive.
      server {
        # port to listen on. Can also be set to an IP:PORT
        listen 80;
    
        # Set the max size for file uploads to 50Mb
        client_max_body_size 50M;

        # sets the domain[s] that this vhost server requests for
        # server_name www.[engineyard].com [engineyard].com;

        # doc root
        root /data/ez/current/public;

        # vhost specific access log
        access_log  /var/log/nginx.vhost.access.log  main;

        # this rewrites all the requests to the maintenance.html
        # page if it exists in the doc root. This is for capistrano's
        # disable web task
        if (-f $document_root/system/maintenance.html) {
          rewrite  ^(.*)$  /system/maintenance.html last;
          break;
        }

        location / {
          # needed to forward user's IP address to rails
          proxy_set_header  X-Real-IP  $remote_addr;

          # needed for HTTPS
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
          proxy_redirect false;
          proxy_max_temp_file_size 0;
      
          # If the file exists as a static file serve it directly without
          # running all the other rewite tests on it
          if (-f $request_filename) { 
            break; 
          }

          # check for index.html for directory index
          # if its there on the filesystem then rewite 
          # the url to add /index.html to the end of it
          # and then break to send it to the next config rules.
          if (-f $request_filename/index.html) {
            rewrite (.*) $1/index.html break;
          }

          # this is the meat of the rails page caching config
          # it adds .html to the end of the url and then checks
          # the filesystem for that file. If it exists, then we
          # rewite the url to have explicit .html on the end 
          # and then send it on its way to the next config rule.
          # if there is no file on the fs then it sets all the 
          # necessary headers and proxies to our upstream mongrels
          if (-f $request_filename.html) {
            rewrite (.*) $1.html break;
          }

          if (!-f $request_filename) {
            proxy_pass http://mongrel;
            break;
          }
        }

        error_page   500 502 503 504  /500.html;
        location = /500.html {
          root   /data/ez/current/public;
        }
      }

      # This server is setup for ssl. Uncomment if 
      # you are using ssl as well as port 80.
      server {
        # port to listen on. Can also be set to an IP:PORT
        listen 443;
    
        # Set the max size for file uploads to 50Mb
        client_max_body_size 50M;

        # sets the domain[s] that this vhost server requests for
        # server_name www.[engineyard].com [engineyard].com;

        # doc root
        root /data/ez/current/public;

        # vhost specific access log
        access_log  /var/log/nginx.vhost.access.log  main;

        # this rewrites all the requests to the maintenance.html
        # page if it exists in the doc root. This is for capistrano's
        # disable web task
        if (-f $document_root/system/maintenance.html) {
          rewrite  ^(.*)$  /system/maintenance.html last;
          break;
        }

        location / {
          # needed to forward user's IP address to rails
          proxy_set_header  X-Real-IP  $remote_addr;

          # needed for HTTPS
          proxy_set_header X_FORWARDED_PROTO https;

          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $http_host;
          proxy_redirect false;
          proxy_max_temp_file_size 0;
      
          # If the file exists as a static file serve it directly without
          # running all the other rewite tests on it
          if (-f $request_filename) { 
            break; 
          }

          # check for index.html for directory index
          # if its there on the filesystem then rewite 
          # the url to add /index.html to the end of it
          # and then break to send it to the next config rules.
          if (-f $request_filename/index.html) {
            rewrite (.*) $1/index.html break;
          }

          # this is the meat of the rails page caching config
          # it adds .html to the end of the url and then checks
          # the filesystem for that file. If it exists, then we
          # rewite the url to have explicit .html on the end 
          # and then send it on its way to the next config rule.
          # if there is no file on the fs then it sets all the 
          # necessary headers and proxies to our upstream mongrels
          if (-f $request_filename.html) {
            rewrite (.*) $1.html break;
          }

          if (!-f $request_filename) {
            proxy_pass http://mongrel;
            break;
          }
        }
        error_page   500 502 503 504  /500.html;
        location = /500.html {
          root   /data/ez/current/public;
        }
      }
    }

### Building a Deployment Recipe with Capistrano

Install Capistrano.

    gem install capistrano

Navigate to your Merb repository directory and run the capify command to create the skeleton for your deployment recipe.

    $ capify .
    [add] writing `./Capfile'
    [add] writing `./config/deploy.rb'
    [done] capified!

Tailor your deploy.rb to meet the requirements of your application

    set :application, "YOUR_APPLICATION_NAME"

    # Set the path to your version control system (Subversion assumed)
    set :repository, "http://something.com/svn/yourapplication/trunk"

    # Set your SVN and SSH User
    set :user, "your_ssh_user"
    set :svn_user, "your_svn_user"
    #Set the full path to your application on the server
    set :deploy_to, "/PATH/TO/YOUR/#{application}"

    #Define your servers
    role :app, "your.appserver.com"
    role :web, "your.webserver.com"
    role :db, "your.databaseserver.com", :primary => true

    desc "Link in the production extras and Migrate the Database ;)"
    task :after_update_code do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{shared_path}/config/merb.yml #{release_path}/config/merb.yml"
      run "ln -nfs #{shared_path}/log #{release_path}/log"
      #if you use ActiveRecord, migrate the DB
      #deploy.migrate
    end

    desc "Merb it up with"
    deploy.task :restart do
      run "cd #{current_path};./script/stop_merb"
      run "cd #{current_path};env EVENT=1 merb -c 3"
    # If you want to run standard mongrel use this:
    # run "cd #{current_path};merb -c 4"
    end

    #Overwrite the default deploy.migrate as it calls: 
    #rake RAILS_ENV=production db:migrate
    #desc "MIGRATE THE DB! ActiveRecord with Merb Love"
    #deploy.task :migrate do
    #  run "cd #{release_path}; rake db:migrate MERB_ENV=production"
    #end

Use Capistrano to initiate the environment, setting up the necessary directories on the server.

    $ cap deploy:setup

Next, install the Gems you need on the Production server.
    
    #Ensure you have the latest version of the gem system
    sudo gem update --system

    sudo gem install merb
    sudo gem install rspec

    # For ActiveRecord
    sudo gem install merb_activerecord
    
    # For DataMapper
    sudo gem install datamapper
    sudo gem install do_mysql

    # For Evented Mongrel
    sudo gem install swiftiply
    
    # For Standard Mongrel
    sudo gem install mongrel
    
    # For Thin
    sudo gem install thin
     
Create the directories and files that will be linked in.

    mkdir /YOURDEPLOYPATH/shared/config
    touch /YOURDEPLOYPATH/shared/config/database.yml
    touch /YOURDEPLOYPATH/shared/config/merb.yml

Edit the .yml files to your liking and then be sure to create your database in MySQL.

Deploy your app:

    cap deploy

You should now have your application deployed to your server with 3 Mongrel instances running being proxied to by Nginx.