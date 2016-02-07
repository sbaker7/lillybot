class Card
    def initialize(shortname, value)
        @shortname = shortname
        @value = value
    end

    def get_shortname
        @shortname
    end

    def get_value
        @value
    end

    def to_s
        @shortname
    end
end
