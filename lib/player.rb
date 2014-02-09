require_relative 'hand'

class Player
  attr_reader :hand, :pot, :name

  def initialize(name, pot = 200)
    @name = name
    @hand = nil
    @pot = pot
  end

  def to_s
    self.name
  end

  def get_new_hand(deck)
    @hand = Hand.deal_from(deck)
  end

  def bet(amount)
    @pot -= amount
    return false if @pot < 0
    
    amount
    # send amount to game pot?
  end

  def add_winnings(amount)
    @pot += amount
    amount
  end

  def ask_for_discards
    puts "\n#{@name}, how many cards would you like to discard?" \
      "\nThis is your current hand: #{@hand}"

    discard_number = gets.chomp.to_i

    discards = []

    puts "Select a card number to discard:" 
    puts (1..5).to_a.join("  ")
    puts @hand
    until discards.uniq.length == discard_number
      selection = gets.chomp.to_i
      discards = (discards + [selection]).uniq
    end
    discards.map! {|index| index - 1}
  end

  def fold_call_or_raise(game)
    puts  "\n#{name},"
    puts  "The current bet is #{game.current_bet}, and current pot is #{game.pot} \n" \
          "Turn order of remaining players: "\
          "#{(game.players_in_round - game.folded_players).map(&:name).join(', ')}"
    puts  "#{game.raising_player.name} was the last to raise." unless game.raising_player.nil?
    puts "You have #{@pot} remaining in your pot and your hand is:"
    puts
    puts @hand
    puts "Would you like to fold, call, or raise?"

    selection = gets.chomp

    case selection.downcase[0]
    when "f" then return :fold
    when "c" then return :call
    when "r" then return :raise
    end
  end

  def get_raise_amount
    puts
    puts "#{name}, how much will you raise by?"
    selection = gets.chomp.to_i
  end


end