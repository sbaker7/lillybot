class Card
    $shortname
    $value

    def initialize(shortname, value)
        $shortname = shortname
        $value = value
    end

    def getShortname
        $shortname
    end

    def getValue
        $value
    end

    def to_s
        $shortname
    end
end
