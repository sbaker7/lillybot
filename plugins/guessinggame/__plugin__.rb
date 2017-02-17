Lilly.plugin.define 'GuessingGame' do

  on(:system_start) do
    # do nothing?
    @guessing_value == nil
  end

  on(:system_stop) do
    # do nothing?
  end

  on(:guess, :guessinggame) do |user, message|
    if message.eql? 'start'
      notify(:start_guessing, user, message)
    elsif @guessing_value == nil
      notify(:start_guessing, user, message)
    else
      notify(:make_guess, user, message)
    end
  end

  on(:start_guessing) do |user, message|
    if @guessing_value == nil
      @guessing_value = rand(50) +1
      "I've started a guessing game! Try guess the number between 1 and 50 using !guess"
    else
      "A guessing game has already been started. Try guess the number between 1 and 50 using !guess"
    end
  end

  on(:make_guess) do |user, message|
    if message.to_i == @guessing_value
      @guessing_value = nil
      @guessing_game = nil
      "Congratulations #{user}, you got it!"
    else
      puts message
      if message.to_i >= 1 &&  message.to_i <= 50
        if message.to_i < @guessing_value
          "Higher, #{user}."
        else
          "Lower, #{user}."
        end
      else
        "You need to guess a number between 1 and 50, #{user}"
      end
    end
  end

  end
