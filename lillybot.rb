require_relative 'lib/twitch/chat'
require_relative 'lib/plugin/plugin'
require_relative 'lib/lilly/lilly'
require 'json'

$configs = JSON.parse(File.read("res/login.json"))

if (!$configs["logdir"])
  $configs["logdir"] = Dir.getwd+'/logs/'
end



Lilly.setLogDirectory($configs["logdir"])

Lilly.plugin.load_plugins __dir__

client = Twitch::Chat::Client.new(channel: $configs["channel"], nickname: $configs["nickname"], password: $configs["password"], logdir: $configs["logdir"]) do

    def send_twitch_message(message)
      send_message message
    end

  on(:connect) do
    send_message 'Hi guys!'
  end

  on(:message) do |user, message|
    responses = []

    # check if the message is a command
    if message.start_with? '!'
      # split the command so it can go out as an event
      parts = /\A!?+(?<command>\w+) ?+(?<args>.*)/.match(message)
      if (Lilly.plugin.accepts(parts[:command]))
        responses << Lilly.plugin.notify(parts[:command], user, parts[:args], self)
      else
        responses << Lilly.plugin.notify('raw_message', user, message)
      end
    else
      responses << Lilly.plugin.notify('raw_message', user, message)
    end
    responses.flatten!.reverse.each { |r| send_message r } if responses.any?
  end
end

client.run!
