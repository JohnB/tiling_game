defmodule TilingGame.Pentomino do
  alias __MODULE__

  @moduledoc """
    Each pentomino square is represented as a grid position in a 5x5 grid.
    However, the 5x5 grid has been flattened to an array, with positions
    represented by a single integer in the range 0..24
    
  """

  @max_dimension 5
  @all_indices [ #leading 0s only for formatting
    [00, 01, 02, 03, 04],
    [05, 06, 07, 08, 09],
    [10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24]
  ]

  @pentominos [
    # monomio or dot
    [0],
    # domino or n-dash
    [0, 1],
    # m-dash or straight-3
    [0, 1, 2],
    # small angle
    [0, 1, 5],
    # straight-4
    [0, 1, 2, 3],
    # short L
    [0, 1, 2, 5],
    # short T
    [0, 1, 2, 6],
    # square
    [0, 1, 5, 6],
    # squiggle
    [1, 2, 5, 6],

    # see image at https://gp.home.xs4all.nl/Pieces.GIF
    # F
    [1, 2, 5, 6, 11],
    # I or straight-5
    [0, 1, 2, 3, 4],
    # L
    [0, 1, 2, 3, 5],
    # N
    [0, 1, 2, 7, 8],
    # P
    [0, 1, 2, 5, 6],
    # big T
    [0, 1, 2, 6, 11],
    # U
    [0, 1, 2, 5, 7],
    # V, or big angle
    [0, 1, 2, 5, 10],
    # W
    [1, 2, 5, 6, 10],
    # X
    [1, 5, 6, 7, 11],
    # Y
    [0, 1, 2, 3, 6],
    # Z
    [1, 2, 6, 10, 11]
  ]

  def all do
    @pentominos
  end

  def piece(index) do
    all() |> Enum.fetch(index)
  end

  def index_to_xy(index) do
    [x, y] = [Integer.mod(index, @max_dimension), Integer.floor_div(index, @max_dimension)]
  end

  def xy_to_index([x, y], width \\ @max_dimension) do
    x + width * y
  end

  def flip_top_to_bottom(pentomino) do
    Enum.map(pentomino, fn index ->
      [x, y] = index_to_xy(index)
      xy_to_index([x, @max_dimension - 1 - y])
    end)
  end

  def flip_side_to_side(pentomino) do
    Enum.map(pentomino, fn index ->
      [x, y] = index_to_xy(index)
      xy_to_index([@max_dimension - 1 - x, y])
    end)
  end

  def rotate_left(pentomino) do
    Enum.map(pentomino, fn index ->
      [x, y] = index_to_xy(index)
      xy_to_index([y, @max_dimension - 1 - x])
    end)
  end

  def rotate_right(pentomino) do
    pentomino |> rotate_left |> rotate_left |> rotate_left
  end

  # Since a board is stored as flattened rows across something that looks like a flat array,
  # placing a piece requires "smearing" the piece with row-offsets equal to the width of the board.
  def smear(pentomino, board_width) do
    pentomino
    |> Enum.map(fn index -> board_offset(index, board_width) end)
  end

  def board_offset(index, board_width) do
    index
    |> index_to_xy
    |> xy_to_index(board_width)
  end

  # Drawing with text will likely never be needed, but is handy for debugging
  def draw(pentomino, color \\ "x") do
    Enum.each(@all_indices, fn row ->
      Enum.map(row, fn index ->
        if index in pentomino do
          color
        else
          " "
        end
      end)
      |> IO.puts()
    end)
  end

  def drawl(color \\ "x") do
    Enum.each(@pentominos, fn pentomino -> draw(pentomino, color) end)
  end

@usage """

alias TilingGame.Pentomino
alias TilingGame.Board

index = 17
{:ok, pentomino} = Pentomino.piece(index)
Pentomino.draw(pentomino, "R")
pentomino = Pentomino.flip_top_to_bottom(pentomino)
Pentomino.draw(pentomino, "Y")

"""
end
