require 'json'

testdata = JSON.parse(File.read('configs/commands.json'))

def print_val(message)
    "it worked! your message was: " + message
end

loop {
    message = gets.chomp
    valid_keys = testdata.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
    if valid_keys
        begin
            puts eval(testdata[valid_keys])
        rescue SyntaxError => ex
            puts testdata[valid_keys]
        rescue => ex
            puts String.interpolate(testdata[valid_keys])
        end
    else
        puts "I couldn't find that key"
    end
}
