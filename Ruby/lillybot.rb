require_relative './lib/twitch/chat'
require 'json'

def say_hello(user, message)
    if user != "astrious" && user != "dragnflier" && user != "catbag"
        send_message JSON.parse(File.read("responses.json"))["greetings"].sample.sub!("user", "#{user}")
    else
        if user == "astrious"
            send_message "Hi Astrious, I missed you! Ready to stream again today? <3"
        else
            send_message "#{user}! How are you? I missed you!"
        end
    end
end

def be_touched(user)
    if user != "astrious" && user != "dragnflier"
        send_message ".timeout #{user} 1"
        send_message "Don't touch me there!"
    else
        send_message "*blushes*" if user == "astrious"
        send_message "That's for later, #{user} <3" if user == "dragnflier"
    end
end

def be_disgusted(user)
    send_message ".timeout #{user} 1"
    send_message "You're disgusting..."
end

# def spam_bot(spam = true)
#     Thread.new do |spam|
#         while (spam)
#             SCHEDULER.every '1800s', :first_in => 0 do
#                 send_message "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"
#     end
# end

def play_slots(user, message)
    file = File.read("responses.json")
    responses = JSON.parse(file)
    faces = nil
    if message =~ /cat/i
        faces = responses["catslots"]
    else
        if message =~ /dog/i
            faces = responses["dogslots"]
        else
            faces = responses["slots"]
        end
    end

    face1 = faces.sample
    face2 = faces.sample
    face3 = faces.sample

    if face1 == face2 && face2 == face3
        if face1 == 'Kappa'
            send_message "Oh dear. Bad luck, #{user}!"
            send_message ".timeout #{user} 60"
        else
            if face1 =='AssFace'
                send_message "What a cutie! <3"
            else
                if face1 == 'FrankerZ' || face1 == 'LilZ'
                    send_message "I love dogs!"
            end
        end
        send_message "Congratulations!"
    end
    else
        if (face1 == face2) || (face1 == face3) || (face2 == face3)
            send_message "So close!"
        else
            send_message "Better luck next time!"
        end
    end
    send_message "You rolled: #{face1} #{face2} #{face3}"
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
    if val == nil
        val = rand(50) +1
        send_message "I've started a guessing game! Try guess the number between 1 and 50 using !guess"
    else
        send_message "A guessing game has already been started. Try guess the number between 1 and 50 using !guess"
    end
end

def make_guess(user, guess)
    if guess == val
        send_message "Congratulations #{user}, you got it!"
        val = nil
    else
        if guess < val
            send_message "Higher, #{user}."
        else
            send_message "Lower, #{user}."
    end
end

client = Twitch::Chat::Client.new(channel: 'dragnflier', nickname: 'dragnflier', password: 'oauth:r3q976rwwqira80pswjha1xs98me2p') do

    commands = JSON.parse(File.read('commands.json'))
    val = nil

    on(:connect) do
        send_message 'Hi guys!'
    end

    on(:message) do |user, message|
        case message
            when /dragn/i && /\Ah(i|ello|ey)/i then
                say_hello(user, message)
            when /MaiWaifu/ then
                send_message "MaiWaifu"
            when /\A!\S*touch\Z/i then
                be_touched(user)
            when /\A!\S*(anal|cock|penis|pen15|vagina|pussy)\Z/i then
                be_disgusted(user)
            when /LillyBag/ then
                send_message "CatBag + MaiWaifu = LillyBag"
            when /CatBag/ then
                send_message "CatBag <3"
            when /\Athank.*\ALilly\Z/i then
                send_message "You're welcome, #{user}"
            when /dragn/i && /how are you/i then
                send_message "I'm feeling good, #{user}. Thanks for asking"
            when /dragn/i && /right/i then
                send_message "I have no idea what you're talking about, #{user}"
            when /dragn/i && /se(n|m)pai/i then
                send_message "You can just call me Lilly, #{user}"
            when /FrankerZ/ then
                send_message "FrankerZ LilZ LilyZ <3"
            when /LilyZ/ then
                send_message "Isn't she cute? LilyZ <3"
            when /Lily/ then
                send_message "Do you mean LilyZ?"
            when /\A!quote/i then
                send_message JSON.parse(File.read('responses.json'))['quotes'].sample
            when /\A!commands/i then
                send_message "I can respond to my name and any of these commands, plus many more: #{JSON.parse(File.read('responses.json'))['commands'].sample}"
            when /\A!time/i then
                send_message "The current time in Melbourne, Australia is #{Time.now.strftime('%I:%M %p')}"
            when /(\A!!|\S.*!!)\Z/ then
                send_message "#{message}!"
            when /\A!.*pat/i then
                send message "*scrunches face at #{user}*"
            when /\A!.*poke/i then
                send_message "Don't do that!"
                send_message ".timeout #{user} 1"
            when /\A!.*kiss/i then
                unless user == "Astrious" || user == "Dragnflier"
                    send_message "I don't think Astrious appreciates that, #{user}"
                else
                    send_message "*blushes*"
                end
            when /\A!.*slots/i then
                play_slots(user, message)
            when /\A!chance/i then
                play_chance(user)
            when /\A!.*(punch|attack)/ then
                send_message "We don't accept violence here"
                send_message ".timeout #{user} 1"
            when /\A!guessinggame/ then
                guessing_game
            when /\A!guess\s\d+/
                make_guess(user, message.scan(/\d+/).first)
            else
                 if commands.key?(message)
                     send_message commands[message].gsub!("user",user)
                 else
                    if message =~ /\A!.*/
                        commands[message] = "This feature has not yet been implemented."
                        File.open("commands.json", "w") do |f|
                            f.write(JSON.pretty_generate(commands))
                        end
                    end
                end
            end
        end
    end

client.run!
