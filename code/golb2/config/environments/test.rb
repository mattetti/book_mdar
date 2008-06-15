Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:testing] = true
  c[:exception_details] = true
  c[:log_auto_flush ] = true
  c[:session_store] = 'memory' 
}

dependencies "merb_stories","webrat"

Merb::BootLoader.after_app_loads do
  Merb::Mailer.delivery_method = :test_send
end