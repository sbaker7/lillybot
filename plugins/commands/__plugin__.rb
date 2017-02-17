require 'cleverbot'
require 'json'

Lilly.plugin.define 'Commands' do

  on(:system_start) do
    path = File.expand_path('../res/commands.json', __FILE__)
    file = File.read(path)
    $configs = JSON.parse(File.read("../../res/login.json"))
    @commands = JSON.parse(file)
    @bot = Cleverbot.new($configs["clever_user"], $configs["clever_api_key"])
  end

  on(:system_stop) do
    # do nothing?
  end

  on(:clever_lilly) do |user, message|
    @bot.say(message.downcase.sub!('lilly', ''))
  end

  on(:raw_message) do |user, message|

    if (!@commands)
      @commands = JSON.parse(File.read(File.expand_path('../res/commands.json', __FILE__)))
    end

    valid_key = @commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
    if valid_key
      responses = @commands[valid_key]
    else
      if message =~ /\A!.*/
        new_commands[message] = "That feature has not yet been implemented."
        File.open("res/new_commands.json", "w") do |f|
          f.write(JSON.pretty_generate(new_commands))
        end
        responses = eval("\"#{@commands[valid_key]}\"")
      elsif message =~ /lilly/i
        responses = notify(:clever_lilly, user, message)
      end
    end
    responses
  end
end
