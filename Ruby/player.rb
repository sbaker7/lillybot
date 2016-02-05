require_relative "card"

class Player
    $user = nil
    $hand = []
    $total = 0
    $state = "p"

    def initialize(user, firstdraw)
        puts "The card is #{firstdraw}"
        $user = user
        $hand<< firstdraw
        $total += firstdraw.getValue
    end

    def draw(newcard)
        puts "The card is: #{newcard}"
        if ($state == "p")
            $hand << newcard
            $total += newcard.getValue
            $state = "b" if $total > 21
            $state = "w" if $total == 21
        end
    end

    def stand
        $state = "s"
    end

    def getPlayer
        $user
    end

    def getHand
        $hand
    end

    def getState
        $state
    end

    def getTotal
        $total
    end

    def to_s
        $user.to_s
    end
end
