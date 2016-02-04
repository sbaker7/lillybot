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

def say_commands
    send_message "I can respond to my name and any of these commands, plus many more: #{JSON.parse(File.read("responses.json"))["commands"].join(", ")}"
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

def spam_bot(spam = true)
    Thread.new do |spam|
        while (spam)
            SCHEDULER.every '1800s', :first_in => 0 do
                send_message "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"
    end
end

def send_quote
    send_message JSON.parse(File.read("responses.json"))["quotes"].sample
end

def play_slots(user, message)
    file = File.read("responses.json")
    faces = nil
    if message =~ /cat/i
        faces = JSON.parse(file)["catslots"]
    else
        if message =~ /dog/i
            faces = JSON.parse(file)["dogslots"]
        else
            faces = JSON.parse(file)["slots"]
    end

    face1 = faces.sample
    face2 = faces.sample
    face3 = faces.sample

    send_message "You rolled: #{face1}, #{face2}, #{face3}"

    if face1 == face2 == face3
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
    else
        if (face1 == face2) || (face1 == face3) || (face2 == face3)
            send_message "So close!"
        else
            send_message "Better luck next time!"
        end
    end
end



client = Twitch::Chat::Client.new(channel: 'dragnflier', nickname: 'dragnflier', password: 'oauth:r3q976rwwqira80pswjha1xs98me2p') do
    on(:connect) do
        send_message 'Hi guys!'
    end

    on(:message) do |user, message|
        send_message "The current time in Australia is #{Time.now.strftime("%I:%M %p")}" if message == '!time' #if !time is the whole sentence
        send_message "I have no idea what you're talking about, #{user}" if message =~ /dragn/i && message =~ /right/i #if matches dragn and right in a sentence
        send_message "MaiWaifu" if message == "MaiWaifu"
        send_message "I'm Lilly Satou from the Visual Novel Kawata Shoujo. I suggest you give it a try ;)" if message == '!feels'
        send_message "I'm feeling good, #{user}. Thanks for asking" if message =~ /dragn/i && message =~ /how are you/i
        send_message ".timeout #{user} 1" if message =~ '!banme'
        send_message "You're welcome, #{user}" if message =~ /\Athank.*\ALilly\Z/i
        send_message "I was written by Astrious' other wife, Dragnflier" if message == '!mycreator'
        send_message "I <3 bacon" if message == '!bacon'
        send_message "TeaCup" if message == '!tea'
        send_message "CatBag <3" if message =~ /CatBag/
        send_message "CatBag + MaiWaifu = LillyBag" if message =~ /LillyBag/
        send_message "*scrunches face at #{user}*" if message

        say_hello(user, message) if message =~ /dragn/i && message =~ /\Ah(i|ello|ey)/i #if matches dragn and hi/hello/hey in sentence
        be_touched(user) if message =~ /!\S*touch\Z/i #
        say_commands if message == '!commands'
        be_disgusted(user) if message =~ /!\S*anal\Z/i

        spam_bot(true) if message =~ /!sellout/i && message =~ /\Aon\Z/i
        spam_bot(false) if message =~ /!sellout/i && message =~ /\Aon\Z/i

        send_quote if message == '!quote'

    end

end

client.run!
