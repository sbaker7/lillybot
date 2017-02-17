Lilly.plugin.define 'Slots' do

  on(:system_start) do
    path = File.expand_path('../res/faces.json', __FILE__)
    file = File.read(path)
    @faces = JSON.parse(file)
  end

  on(:system_stop) do
    # do nothing?
  end

  def roll_slots(user, slots)
    faces = @faces[slots]

    face1 = faces.sample
    face2 = faces.sample
    face3 = faces.sample

    responses = ["You rolled: #{face1} #{face2} #{face3}"]
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

    responses
  end

  on(:dogslots) do |user, message|
    responses = roll_slots(user, "dogslots")
  end

  on(:catslots) do |user, message|
    responses = roll_slots(user, "catslots")
  end

  on(:slots) do |user, message|
    responses = roll_slots(user, "slots")
  end

end
