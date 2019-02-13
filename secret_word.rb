class SecretWord
	def initialize()
		@chosen_line = nil
		pick_random_line
	end

	def pick_random_line
		line = IO.readlines('./5desk.txt')
		c = rand*line.length.to_i
		assign_chosen_line(line[c-1])
	end


	def assign_chosen_line(line)
		if line.length > 5 && line.length < 12
			@chosen_line = line
		else
			pick_random_line
		end	
	end

	def line_chosen
		@chosen_line
	end
end

