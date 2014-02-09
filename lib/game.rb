load './player.rb'
load './deck.rb'

class Game

  #attrs: players, pot, players_in_round, ante, current_bet, deck
  attr_reader :pot, :ante, :current_bet, :players_in_round, :raising_player, :folded_players

  def initialize(players = [], ante = 10)
    @players = players
    @pot = 0
    @players_in_round = []
    @ante = ante
    @deck = Deck.new.shuffle
  end

  def add_player(player)
    puts "#{player.name} has joined the table."
    @players += [player]

    self
  end

  def boot_player(player)
    puts "#{player.name} has left the table"
    @players.delete(player)
  end

  def play_game
    puts "Welcome to poker #{@players.join(', ')}"
    play_hand

    loop do
      puts
      puts "Play another hand?"
      response = gets.chomp
      break if response[0].downcase == "n"
      play_hand
    end

    puts "Hope you had fun. Here's what everyone ended up with:"
    puts "#{@players.map {|player| [player.name, player.pot].join(': ') }.join(', ') }"

  end

  def play_hand
    @players_in_round = @players.unshift(@players.pop)
    @players_in_round.each {|player| player.get_new_hand(@deck) }

    @pot = 0

    ante_sequence

    bet_sequence
    if @players_in_round.length > 1
      discard_sequence
      bet_sequence
    end

    winner = self.determine_winner
    puts
    puts "#{winner.name} wins this round with a hand of: "
    puts winner.hand
    puts "The pot was #{@pot}."
    winner.add_winnings(@pot)

  end

  def attempt_player_bet(player, amount)
    if player.bet(amount)
      @pot += amount
      return true
    else
      boot_player(player)
      @players_in_round.delete(player)
      return false
    end
  end

  def ante_sequence
    puts "Ante up!"
    @players_in_round.each do |player|
      attempt_player_bet(player, @ante)
    end
  end

  def bet_sequence
    @current_bet = @ante
    @raising_player = nil

    until @players_in_round.length == 1
      @folded_players = []

      @players_in_round.each do |player|
        return if player == @raising_player || (@players_in_round - @folded_players == 1)

        action = player.fold_call_or_raise(self)
        handle_action(action, player)
      end

      @players_in_round -= @folded_players
      return if @raising_player.nil?
    end
  end

  def handle_action(action, player)
    case action
    when :fold 
      #can't delete immediately, or it'll mess up the each enumeration
      @folded_players += [player]
    when :call
      attempt_player_bet(player, @current_bet)
    when :raise
      raise_amount = player.get_raise_amount
      if attempt_player_bet(player, (@current_bet + raise_amount))
        @current_bet += raise_amount
        @raising_player = player
      end
    end
  end

  def determine_winner
    @players_in_round.sort_by { |player| player.hand }.first
  end
  
  def pay_out(winner)
    winner.add_winnings(@pot)
  end

  def discard_sequence
    @players_in_round.each do |player|
      discards = player.ask_for_discards
      player.hand.discard(discards)
      player.hand.draw(discards.length)
      player.hand.sort
    end
  end

end