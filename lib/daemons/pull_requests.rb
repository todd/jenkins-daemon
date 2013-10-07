#!/usr/bin/env ruby
require 'daemon_helper'

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

Rails.logger = ActiveSupport::BufferedLogger.new(Rails.root.join('log',"pull_requests.#{Rails.env}.log"))
if Rails.env.production?
  Rails.logger.level = ActiveSupport::BufferedLogger::Severity::INFO
end

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  # Replace this with your code
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  DaemonHelper.process_pull_requests


  
  12.times do 
    sleep 5
    break unless $running # terminate slee if TERM
  end

end
