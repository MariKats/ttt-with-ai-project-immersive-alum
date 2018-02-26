module Players
  class Human < Player
    def move(board)
      print "\nPlayer #{self.token}, Where do you want to move? Please select 1-9: "
      response = gets.chomp
    end
  end
end
