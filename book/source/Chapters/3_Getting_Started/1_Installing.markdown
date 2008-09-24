## Getting Started

<a href="http://xkcd.com/303/" target="_blank"> <img src="http://imgs.xkcd.com/comics/compiling.png" alt="XKCD - Compiling"> </a>

Before we get started I'm going to assume you have the following installed:

* [Ruby](http://www.ruby-lang.org/) 
* [RubyGems >= 1.1.0](http://www.rubygems.org/)
* A DBMS (we'll use [MySQL](http://mysql.org/))
* [SVN](http://subversion.tigris.org/) and [git](http://git.or.cz/)

#### What will be covered

* Installing Merb, DataMapper and RSpec
* Creating a temporary test app
* The basic directory structure for the framework

### The Easy Way

If you're on a *nix operating system then keeping up to date with all the edge 
versions of these gems can be made really easy by using the Sake tasks.

Merb sake tasks can be found in merb-more repository under tools directory.
Sake tasks for DataMapper are in dm-dev repository at
http://github.com/dkubb/dm-dev/.

To install Sake tasks run sake -i PATH where PATH is path to Sake tasks file
on your local machine. For example,

    sake -i ~/dev/opensource/merb/merb-more/tools/merb-dev.rake

To do a fresh clone of all repositories use sake dm:clone and	merb:clone,
respectively. And then to keep up to date you just need to execute:

    sake dm:update

and

    sake merb:update

to update Merb and DataMapper gems.

But what you really want is probably to wipe out Merb and DM gems before update,
do the update and install new updated gems. Use sake merb:gems:refresh and dm:gems:refresh to do so.

### If You're Hardcore

#### Installing Merb
***
If you have an older version of Merb (<0.9.2) you should remove all merb and 
datamapper related gems before continuing. Use `gem list` to see your installed
gems. The following command will uninstall the gem you specify:

    sudo gem uninstall the_gem_name
***
Installing the `merb` gems should be as simple as:
    
    sudo gem install merb --source http://merbivore.org
    
*or for JRuby:*
    
    jruby -S gem install merb mongrel 
    
__Unfortunately__ we are living right on the edge of development so we'll need 
to get down and dirty with building our own gems from source. Luckily this is 
much easier than it sounds... 

Start by installing the `gem` dependancies:

    sudo gem install rack mongrel json erubis mime-types rspec hpricot \
        mocha rubigen haml markaby mailfactory ruby2ruby

*or for JRuby:*

    jruby -S gem install rack mongrel json_pure erubis mime-types rspec hpricot \
        mocha rubigen haml markaby mailfactory ruby2ruby

Then download the `merb` source:

    git clone git://github.com/sam/extlib.git
    git clone git://github.com/wycats/merb-core.git
    git clone git://github.com/wycats/merb-plugins.git
    git clone git://github.com/wycats/merb-more.git

Then install the gems via rake:

    cd extlib ; rake install ; cd ..
    cd merb-core ; rake install ; cd ..    
    cd merb-more ; rake install ; cd ..
    cd merb-plugins; rake install ; cd ..

Note that Merb and DataMappers share Extlib library since after 0.9.3 release of DM.
The `json_pure` gem is needed for merb to install on [JRuby](http://jruby.codehaus.org/) (Java implementation of a Ruby Interpreter), otherwise use the `json` gem as it's faster.

Merb is ORM agnostic, but as the title of this book suggests we'll be using 
DataMapper. Should you want to stick with ActiveRecord or play with Sequel, 
check the [Merb documentation](http://merb.rubyforge.org/files/README.html) for install instructions.

#### Installing DataMapper

***
DataMapper has spit into the gems `dm-core` and `dm-more`, the old `datamapper` 
gem is now outdated.

If you have an older version of `datamapper`, `data_objects`, or `do_mysql`, 
`merb_datamapper` (< 0.9) you should remove them first.
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
