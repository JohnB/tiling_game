defmodule TilingGame do
  @moduledoc """
    board is made up of squares
    a square may be covered by zero or one pieces
    pieces come in X unique pentomino shapes
    each player has one of each shape to play
    first piece played must cover the player’s start square
    subsequent pieces must touch player’s previous pieces at a corner, not an edge
    pieces may not cover other pieces
    pieces must be placed completely on the board
    pieces may be flipped or rotated before placing on the board
    each player has pieces with a distinctive color/pattern (R, Y, G, B)

  """

  @doc """
  Hello world.

  ## Examples

      iex> TilingGame.hello
      :world

  """
  def hello do
    :world
  end
end
