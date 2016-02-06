require_relative "card"

class Deck
  SUITS = ["S", "H", "D", "C"]
  FACE = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  VALUE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

  def initialize(numberOfDecks = 1)
    cards = []
    (1..numberOfDecks).each do |deck|
      (0..(SUITS.length - 1)).each do |i|
        (0..(FACE.length - 1)).each do |j|
          cards << Card.new("#{FACE[j]}#{SUITS[i]}", VALUE[j])
        end
      end
    end
    @availableCards = cards.shuffle
  end

  def is_empty()
    @availableCards.length == 0
  end

  def draw(num = 1)
    cards = []
    (1..num).each do
      cards << @availableCards.pop
    end
    cards
  end

  def to_s
    "\##{@availableCards.length} cards in deck: #{@availableCards.join(",")}"
  end
end
