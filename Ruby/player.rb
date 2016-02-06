require_relative "card"

class Player

    def initialize(user, firstdraw)
        @user = user
        @hand = [firstdraw]
        @total = firstdraw.get_value
        @state = "p"
    end

    def draw(newcard)
        if (@state == "p")
            @hand << newcard
            @total += newcard.get_value
            @state = "b" if @total > 21
            @state = "w" if @total == 21
        end
    end

    def stand
        @state = "s"
    end

    def get_player
        @user
    end

    def get_hand
        @hand
    end

    def get_state
        @state
    end

    def get_total
        @total
    end

    def to_s
        @user.to_s
    end
end
