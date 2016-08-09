require_relative 'core/blackjack'

Lilly.plugin.define 'Blackjack' do

  on(:system_start) do
    # do nothing?
  end

  on(:system_stop) do
    # do nothing?
  end

  # non-conflicting commands
  # !blackjack [rules/start/hit/stand/end]
  on(:blackjack, '21'.to_sym) do |user, message|
    if message.eql? 'rules'
      notify(:rules21)
    elsif message.eql? 'help'
      notify(:help21)
    elsif message.eql? 'start'
      notify(:start21)
    elsif message.eql? 'hit'
      notify(:hit)
    elsif message.eql? 'stand'
      notify(:stand)
    elsif message.eql? 'end'
      notify(:endround)
    else
      "Blackjack doesn't know how to '#{message}'. Try !blackjack help"
    end
  end

  on(:help21, '21help'.to_sym) do
    'Valid commands: !blackjack [rules/help/hit/stand/start/end]'
  end

  on(:rules21, '21rules'.to_sym) do
    'To play 21, ask a moderator to start a 21 game. The aim of the game is to randomly draw cards and get as close as you can to 21. The closest to 21 wins the game. Make sure you get a closer score than I do, or I win. !hit will give you another card, and !stand will signify you don\'t want any more cards. When everybody\'s either standing or busted, it\'ll be my turn!'
  end

  on(:start21, '21start'.to_sym) do
    if @blackjack_game == nil
      @blackjack_game = BlackJack.new
      "I've started a new game of 21. Draw a card with !hit, or !stand if you think you're too close to 21"
    else
      "There's already a blackjack game started, #{user}. Why don't you try !hit"
    end
  end

  # NOTE: for consistency, shouldn't this be :end21?
  on(:endround) do
    responses = @blackjack_game.finish if @blackjack_game != nil
    @blackjack_game = nil if @blackjack_game != nil
    responses
  end

  on(:hit) do |user|
    if @blackjack_game != nil
      responses = @blackjack_game.hit(user)
      @blackjack_game = nil if @blackjack_game.is_finished
      responses
    else
      "There isn't a blackjack game started, #{user}." if @blackjack_game == nil
    end
  end

  on(:stand) do |user|
    if @blackjack_game != nil
      responses = @blackjack_game.stand(user)
      @blackjack_game = nil if @blackjack_game.is_finished
      responses
    else
      "There isn't a blackjack game started, #{user}." if @blackjack_game == nil
    end
  end

end
