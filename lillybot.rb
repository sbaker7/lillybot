require_relative 'lib/log'
require_relative 'lib/twitch/chat'
require_relative 'lib/plugin/plugin'
require 'rufus-scheduler'
require 'json'
require 'cleverbot'

def clever_lilly(message)
        if $bot == nil
            $bot = Cleverbot.new($configs["clever_user"], $configs["clever_api_key"])
        end
        send_message $bot.say(message.downcase.sub!('lilly', ''))
end

def say_hello(user, message)
    if user != "astrious" && user != "dragnflier" && user != "catbag"
        send_message JSON.parse(File.read("configs/responses.json"))["greetings"].sample.sub!("user", "#{user}")
    else
        if user == "astrious"
            send_message "Hi Astrious, I missed you! Ready to stream again today? <3"
        else
            send_message "#{user}! How are you? I missed you!"
        end
    end
end

def be_touched(user, response, timeout = false)
    if user != "astrious" && user != "dragnflier"
        send_message ".timeout #{user} 1" if timeout
        send_message response
    else
        send_message "*blushes*" if user == "astrious"
        send_message "That's for later, #{user} <3" if user == "dragnflier"
    end
end

def be_timed_out(user, response, time)
    send_message ".timeout #{user} #{time}"
    send_message response
end

def toggle_spambot
    if user == "astrious" || user == "dragnflier"
        if message =~ /on/i
            spam_bot(user)
        else
            spam_bot(user, false)
        end
    end
end

def spam_bot(user, spam = true)
    if user == "astrious" || user == "dragnflier"
        if spam
            @scheduler = Rufus::Scheduler.new
            @job = @scheduler.every '10m', first_in: '0s' do
                send_message "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"
            end
        else
            send_message "I can stop now? Being a sell out is tiring work..."
            @scheduler.unschedule(@job)
        end
    end
end

def play_chance(user)
    result = rand(5) + 1
    if result == 3
        send_message "Bad luck, #{user}! You've been timed out for 20 seconds"
        send_message ".timeout #{user} 20"
    else
        send_message "What good luck you have, #{user}!"
    end
    send_message "You rolled: #{result}"
end

def guessing_game
    if @guessing_value == nil
        @guessing_value = rand(50) +1
        send_message "I've started a guessing game! Try guess the number between 1 and 50 using !guess"
    else
        send_message "A guessing game has already been started. Try guess the number between 1 and 50 using !guess"
    end
end

def make_guess(user, guess)
    if guess.to_i == @guessing_value
        send_message "Congratulations #{user}, you got it!"
        @guessing_value = nil
    else
        if guess.to_i < @guessing_value
            send_message "Higher, #{user}."
        else
            send_message "Lower, #{user}."
        end
    end
end

Plugin::Manager.load_plugins __dir__

$configs = JSON.parse(File.read("res/login.json"))

client = Twitch::Chat::Client.new(channel: $configs["channel"], nickname: $configs["nickname"], password: $configs["password"]) do
    commands = JSON.parse(File.read('configs/commands.json'))
    new_commands = JSON.parse(File.read('configs/new_commands.json'))
    @guessing_value = nil
    @blackjack_game = nil

    on(:connect) do
        send_message 'Hi guys!'
    end

    on(:message) do |user, message|
        responses = []

        # check if the message is a command
        if message.start_with? '!'
            # split the command so it can go out as an event
            parts = /\A!?+(?<command>\w+) ?+(?<args>.*)/.match(message)
            responses << Plugin::Manager.notify(parts[:command], user, parts[:args])
        else
            responses << Plugin::Manager.notify(:message, user, message)
        end

        responses.flatten!.reverse.each { |r| send_message r }
    end
end

client.run!
