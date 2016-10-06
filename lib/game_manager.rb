require_relative "../lib/frame"
require_relative "../lib/game"
require_relative "../lib/score_calculator"

class GameManager

  def run
    calculator = ScoreCalculator.new
    games = []

    number_of_players = ask_for_number_of_players

    number_of_players.times do
      games << Game.new
    end

    current_frame = 1

    while current_frame < 11
      games.each_with_index do | game, index |
        player_number = index + 1
        show_frame_header(current_frame, player_number)

        invalid = true
        while invalid
          roll_1 = ask_for_the_first_roll
          roll_2 = ask_for_the_second_roll

          test_frame = Frame.new
          test_frame.roll_1 = roll_1
          test_frame.roll_2 = roll_2
          if !test_frame.invalid
            invalid = false
          end
        end


        game_frame = update_current_frame(current_frame, game, roll_1, roll_2)
        show_score_for_current_player(calculator, game, player_number)
        show_score_for_all_frames(calculator, game)

        generate_bonus_frame(current_frame, game, game_frame)


      end
      current_frame += 1
    end

    display_winner(calculator, games)

  end

  def ask_for_number_of_players
    invalid = true
    player_number = nil
    while invalid
      puts 'Please specify number of players'
      print '> '
      number_of_players = gets.chomp
      puts player_number_whitelist.include? number_of_players
      if player_number_whitelist.include? number_of_players
        invalid = false
        player_number = number_of_players.to_i
      else
        puts
        puts 'Please provide correct number of players'
        puts
      end
    end
    player_number
  end

  def generate_bonus_frame(current_frame, game, game_frame)
    if current_frame == 10 && (game_frame.strike? || game_frame.spare?)
      bonus_frame = game.bonus_frame
      bonus_frame.active = true

      puts
      puts '===========Bonus Frame============='
      puts

      if game_frame.strike?
        roll_1 = ask_for_the_first_roll
        roll_2 = ask_for_the_second_roll
        bonus_frame.roll_1 = roll_1
        bonus_frame.roll_2 = roll_2
        game.bonus_frame = bonus_frame
      end

      if game_frame.spare?
        roll_1 = ask_for_the_first_roll
        bonus_frame.roll_1 = roll_1
        game.bonus_frame = bonus_frame
      end

    end
  end

  def display_winner(calculator, games)
    player_scores = {}

    games.each.with_index do |game, index|
      score = calculator.calculate({frames: game.frames})[:score]
      player_scores[(index + 1)] = score
    end

    player_with_highest_score = player_scores.key(player_scores.values.max)

    puts
    puts '============== WINNER ==========='
    puts "Player: #{player_with_highest_score}, score: #{player_scores[player_with_highest_score]}"
    puts '================================='
  end

  def show_score_for_all_frames(calculator, game)
    puts 'Show scores for all frames?(y/n)'
    answer = gets.chomp

    if answer == 'y'
      frame_hash = calculator.calculate_by_frame(frames: game.frames)
      frame_hash.each do |key, value|
        puts
        puts
        puts '================================'
        puts "Frame #{key} , score: #{value}"
        puts '================================'
        puts
        puts
      end
    end
  end

  def show_score_for_current_player(calculator, game, player_number)
    puts 'Show score for the current player?(y/n)'
    answer = gets.chomp

    if answer == 'y'
      score = calculator.calculate(frames: game.frames)[:score]
      puts
      puts '============================================================'
      puts "Current score for Player: #{player_number} is: #{score}"
      puts '============================================================'
      puts
      puts
    end
  end

  def show_frame_header(current_frame, player_number)
    puts "======== Player #{player_number} ======== Frame #{current_frame}"
    puts
  end

  def update_current_frame(current_frame, game, roll_1, roll_2)
    game_frame = game.frame(current_frame)
    game_frame.roll_1 = roll_1
    game_frame.roll_2 = roll_2
    game_frame.active = true
    game.update_frame(current_frame, game_frame)
    game_frame
  end

  def ask_for_the_second_roll
    invalid = true

    while invalid
      puts 'Please specify number of knocked down pins in the second roll'
      print '> '
      second_roll = gets.chomp

      if roll_number_whitelist.include? second_roll
        invalid = false
      end
    end

    second_roll.to_i
  end

  def ask_for_the_first_roll
    invalid = true
    first_roll = nil
    while invalid
      puts 'Please specify number of knocked down pins in the first roll'
      print '> '
      first_roll = gets.chomp
      if roll_number_whitelist.include? first_roll
        invalid = false
      end
    end

    first_roll.to_i
  end

  def player_number_whitelist
    %w(1 2 3 4)
  end

  def roll_number_whitelist
    %w(0 1 2 3 4 5 6 7 8 9 10)
  end
end