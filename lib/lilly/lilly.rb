require 'logger'

# Lilly module.
#
# Contains all the awesomeness that is Lilly.
# Plugin manager, logger, all the fun stuff.
#
module Lilly
  def self.plugin
    @@plugin ||= Plugin::Manager.new
  end

  def self.log
    @@logger ||= Logger.new 'logs/lillybot.log' , 'daily'
  end
end
