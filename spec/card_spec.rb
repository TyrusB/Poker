# -*- coding: utf-8 -*-
require 'rspec'
require 'card'


describe Card do

  subject(:card) { Card.new(7, :spades) }
  
  it { should respond_to(:value) }
  it { should respond_to(:suit) }

  describe "#to_s" do

    it "prints out its suit and value as a string" do
      expect(card.to_s).to eq("7♠")
    end

  end

  describe "#<=>" do

    it "returns a properly sorted array using Array#sort"
      higher_card = Card.new(10, :diamonds)
      lower_card = Card.new(2, :clubs)

      expect([card, higher_card, lower_card].sort).to eq([lower_card, card, higher_card])
    end

  end

  describe "#==" do

    it "returns equality for a different card of the same suit" do
      same_card = Card.new(7, :spades)

      expect(card == same_card).to be true
    end
  end
end