Lilly.plugin.define 'Chance' do

  on(:system_start) do
    path = File.expand_path('../res/faces.json', __FILE__)
    file = File.read(path)
    @faces = JSON.parse(file)
  end

  on(:system_stop) do
    # do nothing?
  end

  on(:chance) do |user, message|

    result = rand(5) + 1
    responses = ["You rolled: #{result}"]
    if result == 3
        responses << "Bad luck, #{user}! You've been timed out for 20 seconds"
        responses << ".timeout #{user} 20"
    else
        responses << "What good luck you have, #{user}!"
    end
  end

end
