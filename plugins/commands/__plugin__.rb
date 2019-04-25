require 'cleverbot'
require 'json'

Lilly.plugin.define 'Commands' do

  on(:system_start) do
    @configs = JSON.parse(File.read(File.expand_path("../../../res/login.json",__FILE__)))
    @commands = JSON.parse(File.read(File.expand_path('../res/commands.json', __FILE__)))
    @bot = Cleverbot.new(@configs["clever_user"], @configs["clever_api_key"])
    @new_commands = JSON.parse(File.read(File.expand_path('../res/new_commands.json', __FILE__)))
    @responses = JSON.parse(File.read(File.expand_path('../res/responses.json', __FILE__)))
  end

  on(:system_stop) do
    # do nothing?
  end

  def say_hello(user, message)
    if user != "astrious" && user != "dragnflier" && user != "catbag"
      eval("\"#{@responses["greetings"].sample}\"")
    else
      if user == "astrious"
        "Hi Astrious, I missed you! Ready to stream again today? <3"
      else
        "#{user}! How are you? I missed you!"
      end
    end
  end

  def be_touched(user, response, timeout = false)
    responses = []
    if user != "astrious" && user != "dragnflier"
      responses <<  ".timeout #{user} 1" if timeout
      responses << response
    else
      responses << "*blushes*" if user == "astrious"
      responses << "That's for later, #{user} <3" if user == "dragnflier"
    end
  end

  def say_quote(user)
    eval("\"#{@responses["quotes"].sample}\"")
  end

  def create_command(user, message)
    if user == "astrious" || user == "dragnflier"
      command = message.to_s.match(Regexp.new(/\A(!addcomm)\s(!\w+)\s(.+)/i))
      if (command.first === "!addcomm") {
        # lose the first item since we already know and are doing that.
        command = command.drop(1)
      }
      if valid_key = @commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
        "Sorry, #{user} but that command already exists. Did you mean !editcomm?"
      else
        "So you would like me to add #{command.first}? I'll reply with #{command.last}"
      end
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  def edit_command(user, message)
    if user == "astrious" || user == "dragnflier"
      command = message.to_s.match(Regexp.new(/\A(!editcomm)\s(!\w+)\s(.+)/i))
      if (command.first === "!editcomm") {
        # lose the first item since we already know and are doing that.
        command = command.drop(1)
      }

      if valid_key = @commands.keys.select { |key| command.to_s.match(Regexp.new(key, true)) }.first
        "So you would like me to edit #{command.first}? I will reply with #{command.last}"
      else
        "Sorry, #{user} but that command doesn't exist. Did you mean !addcomm?"
      end
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  def delete_command(user, message)
    if user == "astrious" || user == "dragnflier"
      command = message.to_s.match(Regexp.new(/\A(!delcomm)\s(!\w+)/i))
      "I can't delete things quite yet. But just to check, you wanted me to delete #{message.last}?"
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  on(:clever_lilly) do |user, message|
    @bot.say(message.downcase.sub!('lilly', ''))
  end

  on(:unknown_command) do |user, message|
    @new_commands[message] = "That feature has not yet been implemented."
    File.open(File.expand_path('../res/new_commands.json', __FILE__), "w") do |f|
      f.write(JSON.pretty_generate(@new_commands))
    end
    @new_commands[message]
  end

  on(:raw_message) do |user, message|
    if valid_key = @commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
      begin
        Lilly.log.debug @commands[valid_key]
        if @commands[valid_key].kind_of?(Array)
          @commands[valid_key].each { |c| eval("\"#{c}\"")}
        else
          response = eval(@commands[valid_key])
        end
      rescue SyntaxError => ex
        Lilly.log.debug ex.message
        response = eval("\"#{@commands[valid_key]}\"")
      rescue NoMethodError => ex
        Lilly.log.debug ex.message
        response = eval("\"#{@commands[valid_key]}\"")
      rescue NameError => ex
        Lilly.log.debug ex.message
        response = eval("\"#{@commands[valid_key]}\"")
      rescue => ex
        Lilly.log.debug ex
        response = "Whoops, that was almost a problem. Can you tell @dragnflier what you said so she can have a look into why I couldn't respond to that? Thanks #{user}!"
      end
    else
      if message =~ /\A!.*/
        response = notify(:unknown_command, user, message)
      end
    end
  end
end
