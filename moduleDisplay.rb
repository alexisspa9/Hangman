module Display
	def display_welcome_screen
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

	def display_you_won
		puts "\n\e[32mCongratulations you won!!\e[0m\nDo you want to play again? Y/N"
	end

	def display_you_lose(guesses)
		puts "#{display_hangman(guesses)}\n\e[31mYou are hanged!\e[0m\nDo you want to play again? Y/N"
	end

	def display_hidden_word(hidden_word)
		puts "\t\e[36mHidden word: \e[0m#{hidden_word}\n\n"	
	end


	def display_game(guesses, secret, guessed_letters, wrong_letters, games_won)
		display_hangman(guesses)
		display_hidden_word(display_word(secret, guessed_letters))
		puts "Games won: #{games_won}\n"
		puts "You have #{guesses} guesses left\n"
		puts @wrong_letters.length > 0 ? "\e[31mYou tried: #{wrong_letters.join(',')}\e[0m\n" : nil
		puts "Make your guess or type 1 to save your progress:\n"
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

	def display_ask_name
		puts "What is your name?"
	end

	def display_saved(name)
		puts "Your game is saved #{name}. Use your name to access it when you return."
	end

	def display_hangman(guesses)
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
end