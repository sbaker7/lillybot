require_relative "./lib/twitch/chat"
require_relative "card"
require_relative "player"
require 'awesome_print'

class BlackJackGame

    def initialize
        messages = []
        $deck = []
        $players = []
        $stillplaying = 0
        ranks = %w{A 2 3 4 5 6 7 8 9 10 J Q K}
        suits = %w{S H D C}
        puts "initializing!"
        suits.each do |suit|
          ranks.size.times do |i|
              value = 0
              case ranks[i]
                when 'A' then
                    value = 1
                when 'J', 'Q', 'K' then
                    value = 10
                else
                    value = ranks[i]
                end
                $deck << (Card.new("#{ranks[i]}#{suit}", value))
            end
          end
    end

    def getRemaining
        remaining = ["Players remaining: "].concat $players
    end

    def finish
        messages = []
        messages << "It looks like everyone has finished playing, so it must be my turn!"
        me = new Player(self, $deck.delete_at(rand($deck.size)))
        while (me.total < 18)
            me.draw($deck.delete_at(rand($deck.size)))
        end
        messages << "I drew #{me.hand}, giving me a total of #{me.total}. Let's see who won!"

        winners = $players.any?{|a| a.total == 21}
        if winners == nil
            winners = $players.any?{|a| a.total > me.total && a.total < 21}
            if winners != nil
                messages << "The winner(s) are: #{winners}! Congratulations!"
            else
                messages << "I'm the winner! Better luck next time!"
            end
        end
        messages
    end

    def addPlayer(user)
        messages = []
        card = rand($deck.size)
        $players << Player.new(user, $deck[card])
        $deck.delete_at(card)
        messages << "Player #{$players.last.getPlayer} has joined the game! They drew a #{$players.last.getHand.last}, which gives them a total score of #{$players.last.getTotal}"
        $stillplaying += 1
        card = nil
        messages
    end

    def hit(user)
        puts "Remaining cards: #{ap $deck}"
        messages = []
        currentplayerindex = $players.find_index{|a| a.getPlayer == user}
        if currentplayerindex == nil
            messages << addPlayer(user)
        else
            currentplayer = $players[currentplayerindex]
            if currentplayer.getState == "p"
                newcard = rand($deck.length)
                currentplayer.draw($deck.delete_at(newcard))
                case currentplayer.getTotal
                when 1..20 then
                    messages << "#{currentplayer} drew a #{currentplayer.getHand.last}, which gives them a total of #{currentplayer.getTotal}. !hit or !stand?"
                when 21 then
                    messages << "#{currentplayer} drew a #{currentplayer.getHand.last}, which gives them a total of #{currentplayer.getTotal}. Congratulations!"
                else
                    messages <<  "#{currentplayer} drew a #{currentplayer.getHand.last}, which gives them a total of #{currentplayer.getTotal}. That means they've bust! Sorry, #{currentplayer}!"
                end
            else
                messages << "You've already won or busted, #{currentplayer}. Let's wait for everyone else."
            end
        end
        finish if $stillplaying == 0
        newcard = nil
        messages.concat getRemaining
    end

    def stand(user)
        messages = []
        currentplayer = $players.any?{|a| a.user == user}
        if currentplayer != false && currentplayer.getState == "p"
            currentplayer.stand
            $stillplaying -=1
            messages << "#{currentplayer.getPlayer} has chosen to stand. Their total is #{currentplayer.getTotal}. Let's wait for everyone else to finish"
        else
            messages << "You aren't playing the game yet, #{user}. Start with !hit" if currentplayer == false
            messages << "You've either busted or won, #{user}. Let's wait to see what everyone else gets" if currentplayer.state != "p" && currentplayer != false
        end
        messages
    end
end
