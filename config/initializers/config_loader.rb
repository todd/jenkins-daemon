require 'yaml'
require 'ostruct'

raise 'System configuration was already loaded' if defined?( SYSTEM_CONFIG )

root_path           = File.expand_path('../../../', __FILE__)

# System config
#------------------------------------------------------------------------------
#

system_config_path  = File.expand_path('config/system.yml', root_path)
system_config_contents = File.read( system_config_path ) 

SYSTEM_CONFIG = HashWithIndifferentAccess.new YAML::load( system_config_contents.gsub("RAILS_ROOT", root_path) )[Rails.env] 

SystemConfig = OpenStruct.new( SYSTEM_CONFIG )
