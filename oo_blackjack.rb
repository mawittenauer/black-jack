class Card
  attr_accessor :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
  
  def show_suit
    case suit
      when 'H'
        "Heart"
      when 'D'
        "Diamonds"
      when 'C'
        "Clubs"
      when 'S'
        "Spades"
    end
  end
  
  def to_s
    "#{value} of #{show_suit}"
  end
end

class Deck
  attr_accessor :cards
  
  SUITS = %w[H D C S]
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  
  def initialize
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    shuffle!
  end
  
  def shuffle!
    @cards.shuffle!
  end
  
  def count
    @cards.count
  end
  
  def deal_one
    @cards.pop
  end
end

module Hand
  def add_card(card)
    cards << card
  end
  
  def show_cards
    puts "---- #{name}'s hand ----"
    cards.each { |card| puts card }
    puts "For a total of: #{total}"
    puts ""
  end
  
  def total
    total = 0
    
    cards.each do |card|
      if card.value == 'A'
        if total > 10
          total += 1
        else
          total += 11
        end
      elsif card.value.to_i == 0
        total += 10
      else
        total += card.value.to_i
      end
    end
    total
  end
end

class Player
  include Hand
  attr_accessor :name, :cards
  
  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards
  
  def initialize
    @name = "Dealer"
    @cards = []
  end
  
  def show_flop
    puts "---- #{name}'s hand ----"
    puts "#{name}'s first card is hidden"
    puts "Second card: #{cards[1]}"
    puts ""
  end
end

class BlackJack
  attr_accessor :player, :dealer, :deck
  
  def initialize
    puts "What's your name?"
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
  end
  
  def check_for_winner
    if dealer.total == player.total
      puts "It's a draw"
      play_again?
    elsif dealer.total > player.total
      puts "#{dealer.name} wins!"
      play_again?
    else
      puts "#{player.name} wins!"
      play_again?
    end
  end
  
  def black_jack_or_bust?(player, total)
    if total == 21
      player.show_cards
      puts "#{player.name} hit blackjack!"
      play_again?
    elsif total > 21
      player.show_cards
      puts "#{player.name} bust!"
      play_again?
    end
  end
  
  def dealer_turn
    black_jack_or_bust?(dealer, dealer.total)
    dealer.show_cards
    while dealer.total < 17 && dealer.total < player.total
      puts "Dealer chose to hit"
      dealer.add_card(deck.deal_one)
      dealer.show_cards
    end
    black_jack_or_bust?(dealer, dealer.total)
    if dealer.total > 17
      puts "Dealer chose to stay at #{dealer.total}"
      dealer.show_cards
    end
  end
  
  def player_turn
    black_jack_or_bust?(player, player.total)
    loop do
      system 'clear'
      player.show_cards
      dealer.show_flop
      begin
        puts "Would you like to 'hit' or 'stay'?"
        answer = gets.chomp.downcase
      end until ['hit', 'stay'].include?(answer)
    
      if answer == 'stay'
        puts "#{player.name} chose to stay at #{player.total}"
        break
      else
        player.add_card(deck.deal_one)
        black_jack_or_bust?(player, player.total)
      end
    end
  
  end
  
  def initial_deal
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def play_again?
    begin
      puts "Would you like to play again? ('yes' or 'no')"
      play_again = gets.chomp
    end until ['yes', 'no'].include?(play_again)

    if play_again == 'yes'
      self.deck = Deck.new
      player.cards = []
      dealer.cards = []
      play
    else
      puts "Thank's for playing!"
      exit
    end
  end 
  
  def play
    loop do
      initial_deal
      player_turn
      dealer_turn
      check_for_winner
    end
  end
end

BlackJack.new.play


















