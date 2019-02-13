class Play
	require "./gameplay.rb"
	require './moduleDisplay.rb'
	include Display
	
	def initialize()
		@game = Gameplay.new()
		
	end

	def start
		display_welcome_screen
		choice = gets.chomp
		if is_choice_valid(choice.to_i)
			new_game if choice.to_i == 1
			load_game if choice.to_i == 2
		else
			start
		end
	end

	private
	def new_game
		@game.new_game()
	end

	def load_game
		display_ask_name
		player_name = gets.chomp
		@game.load_game(player_name)
	end

	def is_choice_valid(choice)
		(choice == 1 || choice == 2)
	end
end

game = Play.new().start