load './card.rb'

class Deck

  def initialize
    @cards = generate_deck
  end

  # returns an array, regardless of size
  def deal(number = 1)
    raise "Not enough cards left in the deck!" if number > @cards.length
    [@cards.pop(number)].flatten
  end

  def burn_cards(burned_cards_array)
    @cards = burned_cards_array + @cards

    self
  end

  def shuffle
    @cards.shuffle!

    self
  end

  def to_s
    @cards.map{ |card| card.to_s }.join(" ")
  end

  private

    def generate_deck
      [].tap do |new_deck|
        Card::SUIT_TO_STRING.keys.each do |suit|
          (2..14).each do |value|
            new_deck << Card.new(value, suit)
          end
        end
      end
    end

end