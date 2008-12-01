## Getting Started

<a href="http://xkcd.com/303/" target="_blank"> <img src="http://imgs.xkcd.com/comics/compiling.png" alt="XKCD - Compiling"> </a>

Before we get started I'm going to assume you have the following installed:

* [Ruby](http://www.ruby-lang.org/) 
* [RubyGems >= 1.3.0](http://www.rubygems.org/)
* A DBMS (we'll use [MySQL](http://mysql.org/))
* [SVN](http://subversion.tigris.org/) and [git](http://git.or.cz/)

#### What will be covered

* Installing Merb, DataMapper and RSpec
* Creating a temporary test app
* The basic directory structure for the framework

### The Easy Way

		$ sudo gem install rspec
		$ sudo gem install merb
		
Note that the code above will only install drivers for sqlite3, you might also want to install the mysql drivers:

		$ sudo gem install do_mysql

### If You're Hardcore

#### Installing Merb
***
If you have an older version of Merb (<1.0.0) you should remove all merb and 
datamapper related gems before continuing. The easiest way is to execute the following command:

    sudo gem list | grep -E '^((dm|do|merb)[-_a-z]*|data_objects|extlib)' | awk '{print $1}' | xargs sudo gem uninstall -Ixa ;
***

#### Installing DataMapper

***
DataMapper has spit into the gems `dm-core` and `dm-more`, 

***

We will use MySQL in the following example, but you can use either sqlite3 or 
PostgreSQL, just install the appropriate gem. You will also need to ensure that 
MySQL is on your system path for the gem to install correctly.

To get the gems from source:


    git clone git://github.com/sam/extlib.git  
    git clone git://github.com/sam/do.git
    
    cd extlib
    rake install ; cd ..
    cd do
    cd data_objects
    rake install ; cd ..
    cd do_mysql  # || do_postgres || do_sqlite3
    rake install

    git clone git://github.com/sam/dm-core.git
    git clone git://github.com/sam/dm-more.git

    cd dm-core ; rake install ; cd ..
    cd dm-more
    rake install
    
To update a gem from source, run `git pull` and `rake install` again.

#### Install RSpec

The `rspec` gem was installed in the Merb section above. However, if you want 
to grab the source, run one of the following commands:

    gem install -r rspec
    
    # or
    
    git clone git://github.com/dchelimsky/rspec.git
    cd rspec
    rake gem
    sudo gem install pkg/rspec-*.gem
