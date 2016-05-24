class Move
  attr_reader :key

  VALUES = { 'r' => 'rock', 'p' => 'paper', 'sc' => 'scissors', 'l' => 'lizard',
             'sp' => 'spock' }.freeze
  WINNING_COMBINATIONS = [%w(r sc), %w(p r), %w(sc p), %w(r l), %w(l sp),
                          %w(sp sc), %w(sc l), %w(l p), %w(p sp), %w(sp r)].freeze

  def initialize(key)
    @key = key
  end

  def >(other_move)
    WINNING_COMBINATIONS.include?([key, other_move.key])
  end

  def to_s
    VALUES[key]
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end

  def reset_score
    @score = 0
  end

  def increment_score
    self.score += 1
  end
end

class Human < Player
  def set_name
    name = ''
    loop do
      puts "What is your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Please enter your name."
    end
    self.name = name
  end

  def choose
    choice = ''
    loop do
      puts "Make your choice:"
      Move::VALUES.each { |key, value| puts "For #{value}, enter '#{key}'" }
      choice = gets.chomp.downcase
      break if Move::VALUES.keys.include?(choice)
      puts "Please enter a valid choice."
    end
    self.move = Move.new(choice)
    history << move
  end
end

class Computer < Player
  attr_accessor :weights

  ROBOTS = { 'Chappie' => { 'r' => 0.2, 'p' => 0.2, 'sc' => 0.2, 'l' => 0.2, 'sp' => 0.2 },
             'Hal' => { 'r' => 1, 'p' => 0, 'sc' => 0, 'l' => 0, 'sp' => 0 },
             'Sonny' => { 'r' => 0, 'p' => 0.4, 'sc' => 0.3, 'l' => 0.2, 'sp' => 0.1 } }.freeze

  def initialize
    super
    set_weights
  end

  def set_name
    puts "Choose an opponent (enter the corresponding number):"
    ROBOTS.keys.each_with_index { |robot, index| puts "#{index + 1}. #{robot}" }
    choice = ''
    loop do
      choice = gets.chomp.to_i
      break if (1..ROBOTS.size).cover?(choice)
      puts "Please enter a valid number between 1 and #{ROBOTS.size}."
    end
    self.name = ROBOTS.keys[choice - 1]
  end

  def set_weights
    self.weights = ROBOTS[name]
  end

  def create_weighted_values
    weighted_values = []
    weights.each do |key, weight|
      (weight * 100).to_i.times { weighted_values << key }
    end
    weighted_values
  end

  def choose
    self.move = Move.new(create_weighted_values.sample)
    history << move
  end
end

module Display
  def clear_screen
    system('clear') || system('cls')
  end

  def line_break
    puts "-----------------------------------------------------"
  end

  def press_enter_to_continue
    line_break
    puts "Press enter to continue..."
    gets
  end

  def display_welcome_message(winning_score)
    puts "Welcome to #{self}."
    puts "The winner is the first to reach #{winning_score} points. Good luck!"
    press_enter_to_continue
  end

  def display_goodbye_message
    puts "Thank you for playing #{self}. Good bye!"
  end
end

class RPSLSGame
  include Display
  attr_accessor :human, :computer

  WINNING_SCORE = 5

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def to_s
    "Rock, Paper, Scissors, Lizard, Spock"
  end

  def display_scores
    clear_screen
    puts "Current scores: #{human.name}: #{human.score}; "\
         "#{computer.name}: #{computer.score}"
    line_break
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}; "\
         "#{computer.name} chose: #{computer.move}."
  end

  def round_winner
    return human if human.move > computer.move
    return computer if computer.move > human.move
    false
  end

  def display_round_winner
    if round_winner
      puts "#{round_winner.name} won this round!"
    else
      puts "It's a tie!"
    end
  end

  def display_history
    line_break
    puts "#{human.name}'s moves: #{human.history.join(', ')}"
    puts "#{computer.name}'s moves: #{computer.history.join(', ')}"
  end

  def overall_winner
    return human if human.score == WINNING_SCORE
    return computer if computer.score == WINNING_SCORE
    false
  end

  def display_overall_winner
    line_break
    puts "#{overall_winner.name} has #{WINNING_SCORE} points and has won!"
    line_break
  end

  def play_again?
    answer = ''
    puts "Would you like to play again (y/n)?"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts "Enter 'y' to play again or 'n' to quit."
    end
    return true if answer == 'y' || answer == 'yes'
    false
  end

  def change_opponent
    answer = ''
    puts "Would you like to change opponent (y/n)?"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts "Enter 'y' to change opponent or 'n' to stick with #{computer.name}."
    end
    @computer = Computer.new if answer == 'y' || answer == 'yes'
  end

  def play_round
    display_scores
    human.choose
    computer.choose
    display_moves
    display_round_winner
    round_winner.increment_score if round_winner
    display_history
  end

  def restart_game
    human.reset_score
    computer.reset_score
    change_opponent
  end

  def play
    clear_screen
    display_welcome_message(WINNING_SCORE)
    loop do
      loop do
        play_round
        break if overall_winner
        press_enter_to_continue
      end
      display_overall_winner
      break unless play_again?
      restart_game
    end
    display_goodbye_message
  end
end

RPSLSGame.new.play
