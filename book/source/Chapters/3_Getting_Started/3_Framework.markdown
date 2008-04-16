## The Framework

The directory structure of the project created should look like the following. We'll give brief overview of the framework here and go into further details of each component in subsequent chapters.

	test
	  |--> app
	  |--> autotest
	  |--> config
	  |--> log
	  |--> public
	  |--> spec

The `app` folder contains your models, views (including exception pages and layouts) and controllers, helpers. It also has Parts, they inherit from `AbstractController` and similar to the old Rails components, but are lightweight and are useful for sidebars, widgets etc. `Mailers`, which also inherit from the `AbstractController` have their own folder where the controllers and views live. 

	app
	  |--> controllers
	  |--> models (generated with a model)
	  |--> helpers
	  |--> mailers (generated with a mailer)
	  |--> helpers
	  |--> parts (generated with a parts controller)
	  |--> views


The `config` folder has all the configuration files and environments. It's important to edit the `init.rb` and `database.yml` files in here before running Merb. The Merb router, which maps the incoming requests to the controllers is also here. The `rack.rb` file is the rack handler and you can pass options to `merb -a` to change rack adapter.

    config
      |--> environments

RSpec tests can be found in the spec folder.

	spec