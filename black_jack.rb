puts "Enter your name:"
PLAYER_NAME = gets.chomp
SUITS = %w[H D S C]
SUITS_NAMES = { 'H' => 'Hearts', 'S' => 'Spades', 'D' => 'Diamonds', 'C' => 'Clubs' }
CARD_NUMBERS = %w[2 3 4 5 6 7 8 9 10 J Q K A]

def initiate_deck
  deck = []
  CARD_NUMBERS.each do |card|
    SUITS.each { |suit| deck << [card, suit] }
  end
  deck
end

def initiate_game(player_cards, dealer_cards, deck)
  player_cards << deck.pop
  dealer_cards << deck.pop
  player_cards << deck.pop
end

def get_total(cards)
  total = 0
  cards.each do |card|
    if (2..10).include?(card[0].to_i)
      total += card[0].to_i
    elsif card[0] == 'J' || card[0] == 'Q' || card[0] == 'K'
      total += 10
    elsif card[0] == 'A'
      if total <= 10
        total += 11
      else
        total += 1
      end
    end
  end
  total
end

def print_cards(cards)
  cards.each do |card|
    puts "#{card[0]} of #{SUITS_NAMES[card[1]]}"
  end
  puts "For a total of:"
  puts get_total(cards)
end

def player_hit(player_cards, deck)
  puts "Would you like to Hit or Stay?"
  input = gets.chomp.downcase
  if input == 'hit'
    player_cards << deck.pop
  elsif input == 'stay'
    "stay"
  end
end

def dealer_hit(dealer_cards, deck)
  puts "Type 'hit' when you would like to see the dealers next card"
  input = gets.chomp.downcase
  if input == 'hit'
    dealer_cards << deck.pop
  end
end

def print_final(player_cards, dealer_cards)
  system 'clear'
  puts "Player has:"
  print_cards(player_cards)
  puts "Dealer has:"
  print_cards(dealer_cards)
end

loop do
  player_cards = []
  dealer_cards = []
  deck = initiate_deck.shuffle
  initiate_game(player_cards, dealer_cards, deck)

  loop do
    system 'clear'
    puts "#{PLAYER_NAME} has: "
    print_cards(player_cards)
    puts "The dealers first card is a #{dealer_cards[0][0]} of #{SUITS_NAMES[dealer_cards[0][1]]}"

    if get_total(player_cards) > 21
      print_final(player_cards, dealer_cards)
      puts "Player Bust!"
      break
    elsif get_total(player_cards) == 21
      print_final(player_cards, dealer_cards)
      puts "Black Jack! You Win!"
      break
    end

    hit_or_stay = player_hit(player_cards, deck)
    if hit_or_stay == 'stay'
      break
    end

  end

  while get_total(dealer_cards) < 17

    if (get_total(dealer_cards) < 21) && (get_total(player_cards) < get_total(dealer_cards))
      print_final(player_cards, dealer_cards)
      puts "Dealer Wins"
      break
    elsif get_total(dealer_cards) == get_total(player_cards)
      print_final(player_cards, dealer_cards)
      puts "It's a push!"
      break
    end

    if get_total(player_cards) >= 21
      break
    end

    system 'clear'

    puts "#{PLAYER_NAME} has: "
    print_cards(player_cards)
    puts "The dealer has: "
    print_cards(dealer_cards)
    dealer_hit(dealer_cards, deck)

    if get_total(dealer_cards) > 21
      print_final(player_cards, dealer_cards)
      puts "Dealer Bust! You Win!"
      break
    end
  end

  if (get_total(dealer_cards) < 21 && get_total(player_cards) < 21)
    if get_total(dealer_cards) > get_total(player_cards)
      print_final(player_cards, dealer_cards)
      puts "Dealer Wins"
    elsif get_total(dealer_cards) < get_total(player_cards)
      print_final(player_cards, dealer_cards)
      puts "Player Wins"
    elsif get_total(dealer_cards) == get_total(player_cards)
      print_final(player_cards, dealer_cards)
      puts "It's a Tie"
    end
  end

  puts "Would you like to play again?"
  play_again = gets.chomp.downcase

  if play_again == 'no'
    puts "Thanks for playing!"
    break
  end

end
