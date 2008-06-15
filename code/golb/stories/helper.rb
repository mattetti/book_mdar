require 'rubygems'
require 'spec/rake/spectask'
require File.join(File.dirname(__FILE__), "..", "spec", "spec_helper")
require 'spec/mocks'
require 'spec/story'

class Merb::Test::RspecStory
  # Include your custom helpers here
  
  # Include RouterHelper to get url method
  include Merb::Test::RouteHelper
end

class String
  def has_text?(t)
    include?(t)
  end
end

Dir['stories/steps/**/*.rb'].each do |steps_file|
  require steps_file
end
