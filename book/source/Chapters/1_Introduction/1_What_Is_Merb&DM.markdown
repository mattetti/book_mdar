## What's Merb, DataMapper & RSpec?

> If you're not living on the edge, you're taking up too much room. - Alice Bartlett

Merb, DataMapper and RSpec are all open source projects that are great for building kick-ass web applications. They are all in active development and although it can be hard, we'll try our best to keep up-to-date.

### [Merb](http://merbivore.com/)

It's a relatively new framework (a bit like Ruby on Rails) and was created by [Ezra Zygmuntowicz](http://brainspl.at/).  Merb stands for Mongrel + ERB although now it supports the [rack webserver interface](http://rack.rubyforge.org/) so it can user any web server that has rack support (Mongrel, Thin, ebb, etc).

If you know Ruby and have used Rails you're likely to get the hang of Merb quite easily. Noticeable differences between Merb and Rails include its stance on being less opinionated and it's approach to modularisation.
(TODO) - Clarify "opinionated?" doesn't force a particular style?
(TODO) - Add more differences, or change the structure of this sentence to just reflect on one major difference.

Merb consists of a number of gems: `merb-core`, `merb-more` and `merb-plugins`. This means that it is possible to pick and choose the functionality you need, instead of cluttering up the framework with non-essential features. The `merb` gem installs both `merb-core` and `merb-more`; all you need in order to get started straight away. The benefit of this modularity is that the framework remains simple and focussed with additional functionality provided by gems.

Thanks to Merb's modularity, you are not locked into using any particular libraries. For example, Merb ships with plugins for several popular ORMs and provides support for both Test::Unit and RSpec.

`merb-core` alone provides a lightweight framework (a la [camping](http://code.whytheluckystiff.net/camping/)) that can be used to create a simple web app such as an upload server or API provider where the functionality of an all-inclusive framework is not necessary.

### [DataMapper](http://datamapper.org/)

DataMapper is an Object-Relational Mapper (ORM) written in Ruby by Sam Smoot. We'll be using DataMapper with Merb. It's possible to use the same ORM as Rails (ActiveRecord), but as there are plenty of examples of using ActiveRecord already so we've chosen to focus on DataMapper.

DataMapper has some nice features that make it faster than ActiveRecord in some cases. What really stands out for me is the way it handles database attributes. The schema, migrations and attributes are all defined in one place: your model. So you no longer have to look around in your database or other files to see what is defined.

While DataMapper has similarities to ActiveRecord we will be highlighting the differences as we go along.

### [RSpec](http://rspec.info/)

RSpec is a Behaviour Driven Development framework for Ruby. 
Merb currently supports the Test::Unit and RSpec testing frameworks. As the specs for Merb and Datamapper are written in RSpec, we will be covering some aspects of RSpec but it will not be our main focus.

RSpec is 
(TODO) Beef up this section a little. As this section is entitled "What's Merb, DataMapper & RSpec", we should probably spend a little time describing RSpec