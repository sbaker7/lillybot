Plugin::Manager.define 'Slots' do

  on(:system_start) do
    path = File.expand_path('../res/faces.json', __FILE__)
    file = File.read(path)
    @faces = JSON.parse(file)
  end

  on(:system_stop) do
    # do nothing?
  end

  on(:slots) do |user, message|
    faces = nil
    if message.eql? 'cat'
      faces = @faces["catslots"]
    elsif message.eql? 'dog'
      faces = @faces["dogslots"]
    else
      faces = @faces["slots"]
    end

    face1 = faces.sample
    face2 = faces.sample
    face3 = faces.sample

    responses = []
    if face1 == face2 && face2 == face3
        if face1 == 'Kappa'
            responses << "Oh dear. Bad luck, #{user}!"
            responses << ".timeout #{user} 60"
        else
            if face1 =='AssFace'
                responses << "What a cutie! <3"
            else
                if face1 == 'FrankerZ' || face1 == 'LilZ'
                    responses << "I love dogs!"
            end
        end
        responses << "Congratulations!"
    end
    else
        if (face1 == face2) || (face1 == face3) || (face2 == face3)
            responses << "So close!"
        else
            responses << "Better luck next time!"
        end
    end
    responses << "You rolled: #{face1} #{face2} #{face3}"
  end

end
