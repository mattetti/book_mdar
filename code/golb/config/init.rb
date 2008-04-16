# Make the app's "gems" directory a place where gems are loaded from
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

# Make the app's "lib" directory a place where ruby files get "require"d from
$LOAD_PATH.unshift(Merb.root / "lib")


Merb::Config.use do |c|
  
  ### Sets up a custom session id key, if you want to piggyback sessions of other applications
  ### with the cookie session store. If not specified, defaults to '_session_id'.
  # c[:session_id_key] = '_session_id'
  
  c[:session_secret_key]  = '10602fca7eeb4ad3f26fec5734ae1b2678abb239'
  c[:session_store] = 'cookie'
end  

use_orm :dm_core

use_test :rspec

### Add your other dependencies here

# These are some examples of how you might specify dependencies.
# 
dependencies "dm-migration", "merb_helpers"
# OR
# dependency "RedCloth", "> 3.0"
# OR
# dependencies "RedCloth" => "> 3.0", "ruby-aes-cext" => "= 1.0"

Merb::BootLoader.after_app_loads do
  ### Add dependencies here that must load after the application loads:

  # dependency "magic_admin" # this gem uses the app's model classes
end
