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

  def save_commands()
    File.open(File.expand_path('../res/commands.json', __FILE__), "w") do |f|
      f.write(JSON.pretty_generate(@commands))
    end
  end

  def create_command(user, message)
    if user == "astrious" || user == "dragnflier"
      split_message = message.to_s.match(Regexp.new(/\A(?:!addcomm)\s(?<command>!\w+)\s(?<response>.+)/i))
      if valid_key = @commands.keys.select { |key| split_message["command"].to_s.match(Regexp.new(key, true)) }.first
        "Sorry, #{user} but that command already exists. Did you mean !editcomm?"
      else
        @commands.merge!({"\\A#{split_message["command"].to_s}" => split_message["response"].to_s})
        save_commands()
        "Got it. Now when you say #{split_message["command"]}, I will reply with #{split_message["response"]}"
      end
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  def edit_command(user, message)
    if user == "astrious" || user == "dragnflier"
      split_message = message.to_s.match(Regexp.new(/\A(?:!editcomm)\s(?<command>!\w+)\s(?<response>.+)/i))
      if valid_key = @commands.keys.select { |key| split_message["command"].to_s.match(Regexp.new(key, true)) }.first
        @commands[valid_key] = split_message["response"].to_s
        save_commands()
        "Got it. Now when you say #{split_message["command"]}, I will reply with #{split_message["response"]}"
      else
        "Sorry, #{user} but that command doesn't exist. Did you mean !addcomm?"
      end
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  def delete_command(user, message)
    if user == "astrious" || user == "dragnflier"
      split_message = message.to_s.match(Regexp.new(/\A(!delcomm)\s(?<command>!\w+)/i))
      if valid_key = @commands.keys.select { |key| split_message["command"].to_s.match(Regexp.new(key, true)) }.first
        @commands.delete(valid_key)
        save_commands()
        "I seem to have forgotten how to respond to #{split_message["command"]} all of a sudden..."
      else
        "Sorry, #{user}. I don't think that command exists..."
      end
    else
      "Sorry, #{user}. I can't let you do that."
    end
  end

  on(:clever_lilly) do |user, message|
    @bot.say(message.downcase.sub!('lilly', ''))
  end

  on(:unknown_command) do |user, message|
    if @new_commands && @new_commands.is_a?(Hash)
      @new_commands[message] = "That feature has not yet been implemented."
    else
      @new_commands = {message => "That feature has not yet been implemented."}
    end
    File.open(File.expand_path('../res/new_commands.json', __FILE__), "w") do |f|
      f.write(JSON.pretty_generate(@new_commands))
    end
    @new_commands[message]
  end

  on(:raw_message) do |user, message|
    if valid_key = @commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
      begin
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
        Lilly.log.debug ex.message
        if user === "dragnflier"
          response = "#{user}, are you messing with my code again? I have a bit of a headache..."
        else
          response = "Whoops, that was almost a problem. Can you tell @dragnflier what you said so she can have a look into why I couldn't respond to that? Thanks #{user}!"
        end
      end
    else
      if message =~ /\A!.*/
        response = notify(:unknown_command, user, message)
      end
    end
  end
end
