class Play
	require "./gameplay.rb"
	def initialize()
		@game = Gameplay.new()
		
	end

	def start
		show_welcome_screen
		choice = gets.chomp
		if is_choice_valid(choice.to_i)
			new_game if choice.to_i == 1
			load_game if choice.to_i == 2
		else
			start
		end
	end

	def new_game
		@game.new_game()
	end

	def load_game
		puts "Type your name:"
		player_name = gets.chomp
		@game.load_game(player_name)
	end


	private

	def is_choice_valid(choice)
		(choice == 1 || choice == 2)
	end

	def show_welcome_screen()
		puts "\e[36mWELCOME TO HANGMAN\e[0m\n\nThe objective of the game is to guess the letters of a hidden word\n
The hidden word is represented by dashes indicating it's length.\n
The parts of the word are revealed if the guess was \e[32mcorrect\e[0m.\n
If the guess was \e[31mwrong\e[0m, then your incorrect guess is recorded and you get closer to being hanged.
The game is over when you guess all the correct letters to the hidden word or when you run out of guesses.
You have 7 guesses to find the \e[36mhidden word\e[0m
You are allowed to try and guess the whole word at once but if you fail the game ends!\n
\e[36mGOOD LUCK!\e[0m"
	puts "type 1 for new game or 2 to load existing game"
	end

end

game = Play.new()
game.start