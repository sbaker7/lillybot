require 'cleverbot'
require 'json'

Lilly.plugin.define 'Commands' do

  on(:system_start) do
    path = File.expand_path('../res/commands.json', __FILE__)
    file = File.read(path)
    $configs = File.read("../../res/login.json"))
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
    valid_key = @commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
    if valid_key
      puts "Found it!"
      responses = send_message eval("\"#{@commands[valid_key]}\"")
    else
      if message =~ /\A!.*/
        new_commands[message] = "That feature has not yet been implemented."
        File.open("res/new_commands.json", "w") do |f|
          f.write(JSON.pretty_generate(new_commands))
        end
        responses = new_commands[message]
      elsif message =~ /lilly/i
        notify(:clever_lilly, user, message)
      end
    end
  end
end