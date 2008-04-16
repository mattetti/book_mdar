## The Framework
(TODO) - rewrite for 0.9

![Directory Structure](Assets/merb-gen1.png)

This should be the directory structure that was created. We'll give brief overview of the framework here and go into further details of each component in subsequent chapters.


The app folder contains your usual Models (If you have any), Views and Controllers, Helpers. It also has Parts (they inherit from `AbstractController`), similar to the old Rails components, but are lightweight and are useful for sidebars, widgets etc. `Mailers` (which also inherit from the `AbstractController`) have their own folder where the controllers and views live. 

    app
      |--- controllers
      |--- models (generated with a model)
      |--- helpers
      |--- mailers (generated with a mailer)
      |--- helpers
      |--- parts (generated with a parts controller)
      |--- views

The `config` folder has all the configuration files and environments. It's important to edit the `dependencies.rb` and `database.yml` files in here before running Merb. The Merb router, which maps the incoming requests to the controllers, is also defined here (the syntax is not the same as Rails). 

    config
         \--- environments

Lib Folder contains extra stuff, not necessarily loaded on boot, need to add to dependencies. 

(TODO) - better lib desc, loading files etc
    
    lib
    
`public` will hold all your assets, just like rails. 
    
    public
          \--- images
          \--- javascripts
          \--- stylesheets
    
`spec` is for RSpec tests.
    
    spec
        \--- models
        \--- controllers
    
`spec` is for test/unit (same as Rails)
    
    test
        \--- unit
        
`gems` is there so you can package gems with your application, a la Rails plugins
    
    gems
    
 
Unlike Rails there is no `db`, `doc` or `vendor` directory when generating an empty app.