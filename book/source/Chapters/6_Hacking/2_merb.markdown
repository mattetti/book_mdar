## Hacking Merb
(TODO) - Hacking Merb

## 

### Changing the directory structure

    # Build the framework paths.
    #
    # By default, the following paths will be used:
    # application:: Merb.root/app/controller/application.rb
    # config:: Merb.root/config
    # lib:: Merb.root/lib
    # log:: Merb.root/log
    # view:: Merb.root/app/views
    # model:: Merb.root/app/models
    # controller:: Merb.root/app/controllers
    # helper:: Merb.root/app/helpers
    # mailer:: Merb.root/app/mailers
    # part:: Merb.root/app/parts
    #
    # To override the default, set Merb::Config[:framework] in your initialization file.
    # Merb::Config[:framework] takes a Hash whose key is the name of the path, and whose
    # values can be passed into Merb.push_path (see Merb.push_path for full details).
    #
    # ==== Note
    # All paths will default to Merb.root, so you can get a flat-file structure by doing
    # Merb::Config[:framework] = {}
    # 
    # ==== Example
    # {{[
    #   Merb::Config[:framework] = {
    #     :view => Merb.root / "views"
    #     :model => Merb.root / "models"
    #     :lib => Merb.root / "lib"
    #   }
    # ]}}
    # 
    # That will set up a flat directory structure with the config files and controller files
    # under Merb.root, but with models, views, and lib with their own folders off of Merb.root.
    class Merb::BootLoader::BuildFramework < Merb::BootLoader
      class << self

        def run
          build_framework
        end
  
        # This method should be overridden in merb_init.rb before Merb.start to set up a different
        # framework structure
        # DOC: Yehuda Katz FAILED
        def build_framework
          unless Merb::Config[:framework]
            %w[view model controller helper mailer part].each do |component|
              Merb.push_path(component.to_sym, Merb.root_path("app/#{component}s"))
            end
            Merb.push_path(:application,  Merb.root_path("app/controllers/application.rb"))
            Merb.push_path(:config,       Merb.root_path("config"), nil)
            Merb.push_path(:environments, Merb.dir_for(:config) / "environments", nil)
            Merb.push_path(:lib,          Merb.root_path("lib"), nil)
            Merb.push_path(:log,          Merb.log_path, nil)
            Merb.push_path(:public,       Merb.root_path("public"), nil)
            Merb.push_path(:stylesheet,   Merb.dir_for(:public) / "stylesheets", nil)
            Merb.push_path(:javascript,   Merb.dir_for(:public) / "javascripts", nil)
            Merb.push_path(:image,        Merb.dir_for(:public) / "images", nil)        
          else
            Merb::Config[:framework].each do |name, path|
              Merb.push_path(name, Merb.root_path(path.first), path[1])
            end
          end
        end
      end
    end


