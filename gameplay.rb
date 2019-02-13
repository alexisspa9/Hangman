class Gameplay
	require "./secret_word.rb"
	require 'json'
	require './moduleDisplay.rb'
	include Display

	def initialize()
		@secret = nil
		@guesses = 7
		@guessed_letters = []
		@wrong_letters = []
		@games_won = 0
		@name = nil
	end

	def new_game()
		display_ask_name
		@name = gets.chomp
		start_game
	end


	def start_game()
		@secret = SecretWord.new.line_chosen
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

	private

	def play
		start_game_loop
		if game_is_won?(@secret, @guessed_letters)
			@games_won += 1
			display_you_won
			choice = gets.chomp.downcase
			check_play_again(choice)
			exit
		else
			display_you_lose(@choices)
			choice = gets.chomp.downcase
			check_play_again(choice)
			exit
		end
	end

	def start_game_loop
		while @guesses > 0
			display_game(@guesses, @secret, @guessed_letters, @wrong_letters, @games_won)
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
	end

	def check_play_again(choice)
		if choice == "y" || choice == "yes"
			@guesses = 7
			@guessed_letters = []
			@wrong_letters = []
			start_game
		end	
	end

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
  		display_saved(@name)
	  	exit
	end

	def letter?(choice)
	  choice =~ /[[:alpha:]]/
	end

end