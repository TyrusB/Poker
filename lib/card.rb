# -*- coding: utf-8 -*-

class Card

  VALUE_TO_STRING = {
    1 => "1", 
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "5",
    6 => "6",
    7 => "7",
    8 => "8",
    9 => "9",
    10 => "10",
    11 => "J",
    12 => "Q",
    13 => "K", 
    14 => "A"
  }

  SUIT_TO_STRING = {
    clubs: "♣",
    spades: "♠",
    hearts: "♥",
    diamonds: "♦"
  }

  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    VALUE_TO_STRING[@value] + @suit.to_s[0].upcase 
  end

  def ==(other_card)
    return false unless other_card.is_a? Card

    self.to_s  == other_card.to_s
  end

  def <=>(other_card)
    (self.value <=> other_card.value) * -1
  end

end