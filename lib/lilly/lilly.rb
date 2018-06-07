require 'logger'

# Lilly module.
#
# Contains all the awesomeness that is Lilly.
# Plugin manager, logger, all the fun stuff.
#
module Lilly
  attr_accessor :logdir

  def self.plugin
    @@plugin ||= Plugin::Manager.new
  end

  def self.log
    @@logger ||= Logger.new(@logdir+'lillybot.log', 'daily')
  end

  def self.setLogDirectory(logDirectory)
    @logdir = logDirectory
  end
end
