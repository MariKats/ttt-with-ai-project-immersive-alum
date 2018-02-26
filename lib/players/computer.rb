module Players
  class Computer < Player
    def move(board)
      moves = ("1".."9").to_a
      corners = ["1", "3", "7", "9"]
      center = "5"
      sides = ["2", "4", "6", "8"]

      move = nil
      # player one is always human and has X
      human_token = "X"

      if board.turn_count == 1
        # player 1 usually starts with a corner
        if !board.taken?(center)
          # if player 1 takes a corner or side, computer must take the center
          move = "5"
        else
          # if player 1 takes the center, computer should take a corner
          move = corners.find { |c| !board.taken?(c) }
        end

      elsif board.turn_count == 3
        # Player 1 has opposite corners and Player 2 has center
        corners_one_nine = board.position(corners[0]) == human_token && board.position(corners[3]) == human_token
        corners_three_seven = board.position(corners[1]) == human_token && board.position(corners[2]) == human_token
        opposite_corners = corners_one_nine || corners_three_seven ? true : false

        if opposite_corners && board.position(center) == token
          # computer should take a side in order not to lose
          move = sides.find { |s| !board.taken?(s) }
        else
          move = corners.find { |c| !board.taken?(c) }
        end

      else
        # Computer finds a winning combination
        winning_combo = Game::WIN_COMBINATIONS.find do |combo|
          combo.find_all { |pos| board.cells[pos] == token }.size == 2 && combo.any? { |pos| board.cells[pos] == " " }
        end

        # Computer plays to block human
        blocking_combo = Game::WIN_COMBINATIONS.find do |combo|
          combo.find_all { |pos| board.cells[pos] == human_token }.size == 2 && combo.any? { |pos| board.cells[pos] == " " }
        end

        choice = winning_combo ? winning_combo : blocking_combo
        if choice
          empty = choice.find { |pos| board.cells[pos] == " " }
          move = (empty+1).to_s
        else
          moves.sample
        end
      end
    end
  end
end
