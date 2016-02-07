require 'eventmachine'
require 'logger'
require 'active_support/core_ext/hash/keys'
require 'forwardable'
require_relative "chat/version"
require_relative 'chat/client'
require_relative 'chat/connection'
require_relative 'chat/message'
require_relative 'chat/channel'

module Twitch
  module Chat
  end
end
