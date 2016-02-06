require_relative "./lib/twitch/chat"
require_relative "card"
require_relative "player"
require_relative "deck"
require 'awesome_print'

class BlackJackGame

    def initialize
        messages = []
        @deck = Deck.new()
        @players = []
        @stillplaying = 0
    end

    def get_remaining
        @players.any?{|a| a.get_state == "p"}
    end

    def finish
        messages = []
        messages << "It looks like everyone has finished playing, so it must be my turn!"
        me = Player.new(self, @deck.draw)
        while (me.get_total < 18)
            me.draw(@deck.draw)
        end
        messages << "I drew #{me.get_hand}, giving me a total of #{me.get_total}. Let's see who won!"


        if me.get_total == 21
            messages << "I win! Try again next time, everyone!"
        else
            winners = @players.find{|a| a.get_state == "w"}
            if winners != nil
                messages << "The winners are: #{winners}! Congratulations!"
            else
                eligibleplayers = @players.find{|a| a.get_state == "s"}
                if eligibleplayers != nil
                    highscore = eligibleplayers.sort_by{|a| a.get_total} if eligibleplayers.kind_of?(Array)
                    highscore = eligibleplayers.get_total if eligibleplayers.kind_of?(Player)
                    puts "The highscore is #{highscore}"
                    winners = @players.find{|a| a.get_total == highscore}
                    if me.get_total > 21 || (highscore > me.get_total && me.get_total < 21)
                        messages << "The winners are: #{winners} with a score of #{highscore}. Congratulations!"
                    else
                        messages << "I guess I am the winner, with a score of #{me.get_total}! Better luck next time, guys!"
                    end
                else
                    messages << "We've all busted, so I guess no one wins this round." if me.get_total > 21
                    messages << "I guess I am the winner, with a score of #{me.get_total}! Better luck next time, guys!" if me.get_total < 21
                end
            end
        end
        messages
    end

    def add_player(user)
        messages = []
        @players << Player.new(user, @deck.draw)
        messages << "Player #{@players.last.get_player} has joined the game! They drew a #{@players.last.get_hand.last}, which gives them a total score of #{@players.last.get_total}"
        @stillplaying += 1
        card = nil
        messages
    end

    def hit(user)
        puts "Remaining cards: #{@deck}"
        messages = []
        currentplayerindex = @players.find_index{|a| a.get_player == user}
        if currentplayerindex == nil
            messages << add_player(user)
        else
            currentplayer = @players[currentplayerindex]
            puts "#{currentplayer} has a total of #{currentplayer.get_total} and has a state #{currentplayer.get_state}"
            if currentplayer.get_state == "p"
                currentplayer.draw(@deck.draw)
                case currentplayer.get_total
                when 1..20 then
                    messages << "#{currentplayer} drew a #{currentplayer.get_hand.last}, which gives them a total of #{currentplayer.get_total}. !hit or !stand?"
                when 21 then
                    messages << "#{currentplayer} drew a #{currentplayer.get_hand.last}, which gives them a total of #{currentplayer.get_total}. Congratulations!"
                else
                    messages <<  "#{currentplayer} drew a #{currentplayer.get_hand.last}, which gives them a total of #{currentplayer.get_total}. That means they've bust! Sorry, #{currentplayer}!"
                end
            else
                messages << "You've already won or busted, #{currentplayer}. Let's wait for everyone else."
            end
        end
        messages.concat finish if !get_remaining
        messages
    end

    def stand(user)
        messages = []
        if @players.find_index{|a| a.get_player == user} != nil
                currentplayer = @players[@players.find_index{|a| a.get_player == user}]
            if  currentplayer.get_state == "p"
                currentplayer.stand
                messages << "#{currentplayer.get_player} has chosen to stand. Their total is #{currentplayer.get_total}. Let's wait for everyone else to finish"
            else
                if currentplayer.get_state != "p"
                    messages << "You've either busted or won, #{user}. Let's wait to see what everyone else gets"
                end
            end
        else
            messages << "You aren't playing the game yet, #{user}. Start with !hit" if currentplayer == false
        end
        messages.concat finish if !get_remaining
        messages
    end
end
