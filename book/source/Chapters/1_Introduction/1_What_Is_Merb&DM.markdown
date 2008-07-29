## What's Merb, DataMapper & RSpec?

> If you're not living on the edge, you're taking up too much room. - Alice Bartlett

Merb, DataMapper and RSpec are all open source projects that are great for 
building kick-ass web applications. They are all in active development and 
although it can be hard, we'll try our best to keep up-to-date.

### [Merb](http://merbivore.com/)

Merb is a relatively new web framework with an initial 0.0.1 release in October
2006.  [Ezra Zygmuntowicz](http://brainspl.at/) is Merb's creator, and 
continues to actively develop Merb along with a dedicated development team at 
[Engine Yard](http://www.engineyard.com) and many other community contributors.  

Merb has obvious roots and inspiration in the 
[Ruby on Rails](http://www.rubyonrails.com) web framework.  If you know Ruby and
have used Rails you're likely to get the hang of Merb quite easily. 

While there are similarities, Merb is not Ruby on Rails.  There are core 
differences in design and philosophy.  In many areas that Rails chooses to be 
opinionated, Merb is agnostic - with respect to the ORM, the JavaScript library 
and template language. The Merb philosophy also disbelieves in having a monolithic 
framework. Instead, it consists of a number of gems: `merb-core`, `merb-more` and 
`merb-plugins`. This means that it is possible to pick and choose the 
functionality you need, instead of cluttering up the framework with non-essential 
features. 

The `merb` gem installs both `merb-core` and `merb-more`; all you need in order to 
get started straight away.  The benefit of this modularity is that the framework 
remains simple and focused with additional functionality provided by gems.

Thanks to Merb's modularity, you are not locked into using any particular 
libraries. For example, Merb ships with plugins for several popular ORMs and 
provides support for both Test::Unit and RSpec.

`merb-core` alone provides a lightweight framework 
(a la [camping](http://code.whytheluckystiff.net/camping/)) that can be used to 
create a simple web app such as an upload server or API provider where the 
functionality of an all-inclusive framework is not necessary.

### [DataMapper](http://datamapper.org/)

DataMapper is an Object-Relational Mapper (ORM) written in Ruby by Sam Smoot. 
We'll be using DataMapper with Merb. As previously mentioned, Merb does not require 
the use of DataMapper.  You can just as easily use the same ORM as Rails 
(ActiveRecord) if you prefer.

We have chosen to use DataMapper because of it's feature set and performance. One
of the differences between it and ActiveRecord that I find useful is the way 
database attributes are handled. The schema, migrations and attributes are all 
defined in one place: your model. This means you no longer have to look around in 
your database or other files to see what is defined.  

While DataMapper has similarities to ActiveRecord, we will be highlighting the 
differences as we go along.

### [RSpec](http://rspec.info/)

RSpec is a Behaviour Driven Development framework for Ruby. It consists of two
main pieces, a Story framework for integration tests and a Spec framework for
object tests. Both these components are implemented as Domain Specific
Languages which help to make the stories and specs created more readable.

Merb currently supports the Test::Unit and RSpec testing frameworks. Both Merb
and Datamapper use the RSpec testing frameworks and so we will be covering some
aspects so that you may use it for your own applications.
