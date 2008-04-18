Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

$LOAD_PATH.unshift(Merb.root / "lib")

Merb::Config.use do |c|
  
  c[:session_secret_key]  = '10602fca7eeb4ad3f26fec5734ae1b2678abb239'
  c[:session_store] = 'cookie'
end  

use_orm :dm_core

use_test :rspec

dependency "dm-validations"

Merb::BootLoader.after_app_loads do

end
