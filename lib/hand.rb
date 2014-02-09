require_relative 'deck'

class Hand

  RANKED_HAND_TYPES = [:highcard, :pair, :twopair, :three, :straight, :flush, :fhouse, :four, :sflush]

  attr_reader :cards

  def self.deal_from(deck)
    starting_cards = deck.deal(5)
    Hand.new(starting_cards, deck)
  end

  def initialize(cards, deck)
    @cards = cards
    @deck = deck
    self.sort
  end

  def discard(index_positions) 
    cards_to_burn = @cards.select { |card| index_positions.include?(@cards.index(card))}

    @cards.delete_if { |card| cards_to_burn.include?(card) }
    @cards.sort
    @deck.burn_cards(cards_to_burn)

    self
  end

  def draw(number = 1)
    @cards += @deck.deal(number)
    @cards.sort
    self
  end

  def to_s
    @cards.map { |card| card.to_s }.join(" ")
  end

  #need to sort the values by frequencies, then multiply to get the sort
  def sort
    #create an array of cards by each value
    cards_by_value = Hash.new([])
    @cards.each { |card| cards_by_value[card.value] += [card] }
    #sort the values by length first, then value
    sorted_hand = cards_by_value.values.sort do |card_array1, card_array2|
      arr_length1, arr_length2 = card_array1.length, card_array2.length
      if arr_length1 == arr_length2
        card_array2[0].value <=> card_array1[0].value
      else
        arr_length2 <=> arr_length1
      end
    end

    @cards = sorted_hand.flatten

    self
  end

  def <=>(other_hand)
    this_rank, other_rank = RANKED_HAND_TYPES.index(self.ranked_type), RANKED_HAND_TYPES.index(other_hand.ranked_type)

    if this_rank == other_rank
      #tiebreaker; returns 1, 0, or -1
      tiebreak_compare(self, other_hand)
    else
      other_rank <=> this_rank
    end
  end

  protected 

    def tiebreak_compare(hand1, hand2)
      0.upto(4) do |card_index|
        card_val1, card_val2 = hand1[card_index].value, hand2[card_index].value
        next if card_val1 == card_val2

        #reversed because we want largest first
        return card_val2 <=> card_val1
      end
      0
    end  

    def ranked_type
      is_straight, is_flush = straight?, flush?
      pairs = multiples

      return :sflush if is_flush && is_straight
      return :four if pairs.include?(4)
      return :fhouse if pairs.length == 2 && pairs.include?(3)
      return :flush if is_flush
      return :straight if is_straight
      return :three if pairs.include?(3)
      return :twopair if pairs.length == 2
      return :pair if pairs.include?(2)
      return :highcard
    end

    def [](index)
      @cards[index]
    end

  private

    def flush?
      @cards.map { |card| card.suit }.uniq == 1
    end

    def straight?
      card_values = @cards.map { |card| card.value }.sort #sort them to check against a sorted array below
      #test for aces
      if card_values.include?(14)
        aces_low = card_values.map { |value| value == 14 ? 1 : value }.sort
        return aces_low == (1..5).to_a
      end

      low_card = card_values.first
      card_values == (low_card..(low_card + 4)).to_a
    end

    def multiples
      number_of_occurances = Hash.new(0)
      @cards.each { |card| number_of_occurances[card.value] += 1 }

      number_of_occurances.values.select { |value| value > 1 }
    end

end