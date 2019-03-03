defmodule TilingGame.PlacementValidator do
  alias __MODULE__

  @moduledoc """
    Tentatively places a piece on the board, returning details on
    whether it could be placed or not.

    On board
      Not over any piece
      No flat touch to my pieces
      At least one diagonal touch
    
    If first move
      On board
      On start square
      
  """
  
  @colors "RYGB"
#  @offsets_to_adjacent_squares [-1, 1, -width, width]

  def new(board, pentomino, x, y) do
    offsets = Board.board_offsets(board, pentomino, x, y)
    
    offsets_of_existing_pieces = Enum.filter(offsets, fn idx ->
      String.contains?(@colors, board.squares[idx])
    end)
    offsets_of_adjacent_squares = Enum.filter(offsets, fn idx ->
      String.contains?(@colors, board.squares[idx])
    end)
    
    # translate the piece by the top_left_placement_index (offset)
    # and spread the rows out to match the board width.

    # Check the board value at each piece position on the board
    #   nil: that piece square is off the board
    #   " ": we aren't covering a previous piece
    #   "x": on top of color x
    # Return something like this:
    #   {:ok, updated_board}
    #     OR
    #   {:error, %{-2 =>  :off_board, 3 => "covering a previous piece"} }
  end
end
