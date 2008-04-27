## Getting Started

<a href="http://xkcd.com/303/" target="_blank"> <img src="http://imgs.xkcd.com/comics/compiling.png" alt="XKCD - Compiling"> </a>

Before we get started I'm going to assume you have the following installed:

* [Ruby](http://www.ruby-lang.org/) 
* A DBMS (we'll use [MySQL](http://mysql.org/))
* [SVN](http://subversion.tigris.org/) and [git](http://git.or.cz/) (on OSX, port install `git-core` worked for me)

### Installing Merb
***
If you have an older version of Merb (<0.9.2) you should remove the all the gems before continuing. Use `gem list` to see your installed gems.
***
Installing the `merb` gems should be as simple as:
    
    sudo gem install merb --source http://merbivore.org
    
    or for JRuby:
    
    jruby -S gem install merb mongrel 
    
__Unfortunately__ we are living right on the edge of development so we'll need to get down and dirty with building our own gems from source. Luckily this is much easier than it sounds... 

Start by installing the `gem` dependancies:

    sudo gem install rack mongrel json_pure erubis mime-types rspec hpricot \
        mocha rubigen haml markaby mailfactory ruby2ruby

Then download the `merb` source:

    git clone git://github.com/wycats/merb-core.git
    git clone git://github.com/wycats/merb-plugins.git
    git clone git://github.com/wycats/merb-more.git

Then install the gems via rake:

   	cd merb-core ; rake install ; cd ..    
    cd merb-more ; rake install ; cd ..
    cd merb-plugins; rake install ; cd ..

The `json_pure` gem is needed for merb to install on [JRuby](http://jruby.codehaus.org/) (Java implementation of a Ruby Interpreter), otherwise use the `json` gem as it's faster.

Merb is ORM agnostic, but as the title of this book suggests we'll be using DataMapper.
Should you want to stick with ActiveRecord or play with Sequel, check the [merb documentation](http://merb.rubyforge.org/files/README.html) for install instructions.

### Installing DataMapper


***
DataMapper is splitting into `dm-core` and `dm-more` so `datamapper 0.3` will be outdated soon.
If you have an older version of `datamapper`, `data_objects`, or `do_mysql`, `merb_datamapper` (< 0.9) you should remove them first. Remove the `merb_datamapper` gem  before installing `dm-merb` within `dm-more`.
***

We will use MySQL in the following example, but you can use either sqlite3 or PostgreSQL, just install the appropriate gem. You will also need to ensure that MySQL is on your system path for the gem to install correctly.

(TODO) - JDBC_do install

To get the gems from source:

	git clone git://github.com/sam/do.git

	cd do
	cd data_objects
	rake install ; cd ..
	cd do_mysql  # || do_postgres || do_sqlite3
	rake install

    git clone git://github.com/sam/dm-core.git
    git clone git://github.com/sam/dm-more.git

    cd dm-core ; rake install ; cd ..
    cd dm-more
    cd merb_datamapper ; rake install ; cd ..    
    cd dm-migrations ; rake install ; cd ..
    cd dm-validations ; rake install ; cd ..
    
To update a gem from source, run `git pull` and `rake install` again.

### Install RSpec

The `rspec` gem was installed in the Merb section above. However, if for some reason you didn't install it there, or want to grab the it from source, run the following commands:

    gem install rspec
    svn checkout http://rspec.rubyforge.org/svn/trunk rspec_trunk

(TODO) RSpec moved to http://github.com/dchelimsky/rspec/tree/master

### The Easy Way

If you're on a *nix or OSX operating system then keeping upto date with all the edge versions of these gems can be made really easy by using the [Edgy sake tasks](http://edgy.4ninjas.org).

All you need to run to get `RSpec`, `merb-core`, `merb-more`, `dm-core`, `dm-more`, `data_objects` & all the other dependent gems installed automgically is...

		sudo gem install sake
		sake -i 'http://edgy.4ninjas.org/edgy.sake'
		sake edgy:install packages="merb-stack"
		

And then to keep upto date you just need to execute

		sake edgy:update


