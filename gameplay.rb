class Gameplay
	require "./secret_word.rb"
	require 'json'

	def initialize()
		@secret = nil
		@guesses = 7
		@guessed_letters = []
		@wrong_letters = []
		@games_won = 0
		@name = nil
	end

	def new_game()
		puts "What is your name?"
		@name = gets.chomp
		start_game
	end


	def start_game()
		@secret = SecretWord.new.line_chosen.chomp.downcase
		play	
	end

	def load_game(player_name)
		filename = "saved_games/#{player_name.capitalize}.rb"
	  	until File.exist?(filename) do
	  	  puts "There was no saved game under ths name! Please type your name again"
	  	  player_name = gets.chomp
	  	  filename = "saved_games/#{player_name.capitalize}.rb"
	  	end	
	  	saved_game = JSON.parse(File.read(filename))
	  	@name = saved_game["player_name"]
	  	@secret = saved_game["hidden_word"]
		@guesses = saved_game["guesses"]
		@guessed_letters = saved_game["guessed_letters"]
		@wrong_letters = saved_game["wrong_letters"]
		@games_won = saved_game["games_won"]
		play

	end

	def play
		while @guesses > 0
			puts @secret
			print_game(@guesses, @secret, @guessed_letters, @wrong_letters, @games_won)
			choice = gets.chomp.downcase
			if letter?(choice) && choice.length < 2
				puts already_guessed(choice) ? "\e[32mYou already guessed that\e[0m\n" : check_letter(choice)
			elsif letter?(choice) && choice.length > 1
				@guessed_letters = choice.split("")
				@guesses = 0
			elsif choice.to_i == 1
				save_game
			else				
				play
			end
		end
		if game_is_won?(@secret, @guessed_letters)
			@games_won += 1
			puts "\n\e[32mCongratulations you won!!\e[0m\nDo you want to play again? Y/N"
			play_again = gets.chomp.downcase
			if play_again == "y" || play_again == "yes"
				@guesses = 7
				@guessed_letters = []
				@wrong_letters = []

				start_game
			end
		else
			puts "#{print_hangman(@guesses)}\n\e[31mYou are hanged!\e[0m\nDo you want to play again? Y/N"
			play_again = gets.chomp.downcase
			if play_again == "y" || play_again == "yes"
				@guesses = 7
				@guessed_letters = []
				@wrong_letters = []
				@games_won = 0
				start_game
			end
		end
	end

	private

	def check_letter(choice)
		if @secret.include? choice
			@guessed_letters << choice
			@guesses = 0 if game_is_won?(@secret, @guessed_letters)
		else
			@wrong_letters << choice
			@guesses -= 1
		end
	end

	def already_guessed(choice)
		@guessed_letters.include?(choice) || @wrong_letters.include?(choice)
	end

	def game_is_won?(secret, guessed_letters)
		secret.split("").all? {|c| guessed_letters.include? c}		
	end

	def display_word(secret, guessed_letters)
		displayed = []
		secret.split("").each do |c|
			if guessed_letters.include? c
				displayed << c
			else
				displayed << "_ "
			end
		end	
		displayed.join()
	end

	def letter?(choice)
	  choice =~ /[[:alpha:]]/
	end

	def print_game(guesses, secret, guessed_letters, wrong_letters, games_won)
		puts print_hangman(guesses)
		puts "\t\e[36mHidden word: \e[0m#{display_word(secret, guessed_letters)}\n\n"
		puts "Games won: #{games_won}\n"
		puts "You have #{guesses} guesses left\n"
		puts @wrong_letters.length > 0 ? "\e[31mYou tried: #{wrong_letters.join(',')}\e[0m\n" : nil
		puts "Make your guess or type 1 to save your progress:\n"
	end

	def print_hangman(guesses)
		case guesses
		when 7
		  puts "\t    +---+\n\t\t|\n\t\t|\n\t\t|\n\t\t|\n\t\t|\n\t============"
		when 6
		  puts "\t    +---+\n\t    |\t|\n\t\t|\n\t\t|\n\t\t|\n\t\t|\n\t============"
		when 5
		  puts "\t    +---+\n\t    |\t|\n\t    O\t|\n\t\t|\n\t\t|\n\t\t|\n\t============"

		when 4
		  puts "\t\e[33m    +---+\n\t    |\t|\n\t    O\t|\n\t    |\t|\n\t\t|\n\t\t|\n\t============\e[0m"
		when 3
		  puts "\t\e[33m    +---+\n\t    |\t|\n\t    O\t|\n\t   /|\t|\n\t\t|\n\t\t|\n\t============\e[0m"
		when 2
		  puts "\t\e[33m    +---+\n\t    |\t|\n\t    O\t|\n\t   /|\\\t|\n\t\t|\n\t\t|\n\t============\e[0m"
		when 1
		  puts "\t\e[33m    +---+\n\t    |\t|\n\t    O\t|\n\t   /|\\\t|\n\t   /\t|\n\t\t|\n\t============\e[0m"
		else
		  puts "\t\e[31m    +---+\n\t    |\t|\n\t    O\t|\n\t   /|\\\t|\n\t   / \\\t|\n\t\t|\n\t============\e[0m"
		end
		
	end

	def save_game
  	gameFile = {
	  	:player_name => @name,
	  	:hidden_word => @secret,
	    :guesses => @guesses,
	    :guessed_letters => @guessed_letters,
	  	:wrong_letters => @wrong_letters,
	  	:games_won => @games_won
    }

  	Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
  	filename = "saved_games/#{@name}.rb"
  	File.open(filename, 'w') do |file|
  	  file.write(gameFile.to_json)
  	end
  	puts 'Your game is saved. Use your name to access it when you return.'
  	exit

	end



end