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

  def new(width, height, style \\ :blokus) do
    # Initialize the entire valid board to blank squares
    squares = Enum.reduce(1..(width * height), %{}, fn n, acc -> Map.put(acc, n, @default_square) end)

    raw_board = %Board{width: width, height: height, squares: squares}
    {:ok, Board.apply_starting_positions(raw_board, style)}
  end
  
  def index(board, x, y), do: x + (board.width * (y - 1))
  
  # Given a piece, and its top-left position on the board,
  # return the board offsets that it would cover.
  def board_offsets(board, pentomino, x, y) do
    base_index = index(board, x, y)

    Pentomino.smear(pentomino, board.width)
    |> Enum.map(fn offset -> base_index + offset end)
  end

  # When placing a piece, specify the x,y coordinate of the top-left corner of the piece.
  # If the piece has been flipped and we're placing it at the top or left side of the board,
  # we may need a negative X or Y to snug the piece to the edge.
  def place_piece(board, pentomino, x, y, color) do
    try do
      new_squares =
        board_offsets(board, pentomino, x, y)
        |> Enum.reduce(board.squares, fn offset, acc ->
          %{acc | offset => color}
        end)
      # IO.inspect(new_squares)
      {:ok, %{board | squares: new_squares}}
    rescue
      e in RuntimeError -> {:error, inspect(e)}
      e in KeyError -> {:error, "KeyError: " <> inspect(e)}
    end
  end
  
  def cell(board, x, y) do
    offset = index(board, x, y)
    board.squares[offset]
  end
  
  # Generic (read) iterator over the board
  def each_cell(board, after_row_fn, each_cell_fn) do
    (1..board.height)
    |> Enum.each(fn y ->
      (1..board.width)
      |> Enum.each(fn x ->
        each_cell_fn.(cell(board, x, y), x, y)
      end)
      after_row_fn.(y)
    end)
  end
  
  # Drawing with text will likely never be needed, but is handy for debugging
  def draw(board) do
    each_cell(board,
      fn _row_num -> IO.puts("") end,
      fn cell_value, _x, _y -> IO.write(cell_value) end)
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
iex -S mix

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

