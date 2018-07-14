defmodule TilingGame.Board do
  alias __MODULE__
  alias TilingGame.Pentomino

  @moduledoc """
    supposed to represent the board - duh
    NOTE: the top left corner, (1, 1) is array position 1.
      bottom right (width, height) is at array position width*height
      
  """

  @enforce_keys [:width, :height, :squares]
  defstruct [:width, :height, :squares]

  @width_range 10..30
  @height_range 10..35
  @default_square "."

  def new(width, height) when not (width in @width_range and height in @height_range),
    do: {:error, :invalid_board}

  def new(width, height) do
    # Initialize the entire valid board to blank squares
    squares = Enum.reduce(1..(width * height), %{}, fn n, acc -> Map.put(acc, n, @default_square) end)

    {:ok, %Board{width: width, height: height, squares: squares}}
  end
  
  def index(board, x, y), do: x + (board.width * (y - 1))

  # When placing a piece, specify the x,y coordinate of the top-left corner of the piece.
  # If the piece has been flipped and we're placing it at the top or left side of the board,
  # we may need a negative X or Y to snug the piece to the edge.
  def place_piece(board, pentomino, x, y, color) do
    base_index = index(board, x, y)
    smeared_pentomino = Pentomino.smear(pentomino, board.width)
    new_squares =
      smeared_pentomino
      |> Enum.reduce(board.squares, fn offset, acc ->
        %{acc | (base_index + offset) => color}
      end)
    IO.inspect(new_squares)
    %{board | squares: new_squares}
  end
  
  def cell(board, x, y) do
    offset = index(board, x, y)
    board.squares[offset]
  end
  
  # Drawing with text will likely never be needed, but is handy for debugging
  def draw(board) do
    (1..board.height)
    |> Enum.each(fn y ->
      (1..board.width)
      |> Enum.each(fn x ->
        IO.write(cell(board, x, y))
      end)
      IO.puts("")
    end)
  end
  
  def starting_position_offsets(board, _style = :blokus) do
    %{
      1 => "r",
      board.width => "y",
      board.width * board.height => "g",
      1 + board.width * (board.height - 1) => "b",
    }
  end
  
  def apply_starting_positions(board, style) do
    new_squares =
      starting_position_offsets(board, style)
      |> Enum.reduce(board.squares, fn {offset, color}, acc ->
        %{acc | offset => color}
      end)
    %{board | squares: new_squares}
  end

@usage """

alias TilingGame.Pentomino
alias TilingGame.Board

index = 2
{:ok, pentomino} = Pentomino.piece(index)
Pentomino.draw(pentomino, "R")

{:ok, board} = Board.new(10, 12)
Board.draw(board)

board = Board.place_piece(board, pentomino, 3, 6, "Y")
Board.draw(board)
board = Board.place_piece(board, pentomino, 1, 1, "G")
Board.draw(board)

"""
end

