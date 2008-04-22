## Loading The Merb Environment Outside Of Merb

Sometimes you will need to load up a Merb environment (and it's frozen gems) for things such as RSpec stories or cron tasks. This little snippet does just that. 

	env = ENV['MERB_ENV'] || 'test'

	require 'rubygems'
	Gem.clear_paths
	Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

	require 'merb-core'
	Merb.load_dependencies(:environment => env)

	require 'spec'
	Merb.start_environment(:testing => true, :adapter => 'runner', :environment => env)

Here we have assumed that the script is running from the root of your app. In practice though you will most likely want it in a different location so be sure to adjust the `Gem.path` accordingly.