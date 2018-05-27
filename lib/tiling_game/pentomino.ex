defmodule TilingGame.Pentomino do
  alias __MODULE__
  
  @doc """
    Each pentomino square is represented as a grid position in a 5x5 grid.
    However, the 5x5 grid has been flattened to an array, with positions
    represented by a single integer in the range 0..24
    
  """
  
  @max_dimension 5
  @all_indices [
    [ 0,  1,  2,  3,  4],
    [ 5,  6,  7,  8,  9],
    [10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24],
  ]
  
  @pentominos [
    [0], # monomio or dot
    
    [0, 1], # domino or n-dash
    
    [0, 1, 2], # m-dash or straight-3
    [0, 1, 5], # small angle
    
    [0, 1, 2, 3], # straight-4
    [0, 1, 2, 5], # short L
    [0, 1, 2, 6], # short T
    [0, 1, 5, 6], # square
    [1, 2, 5, 6], # squiggle

    # see image at https://gp.home.xs4all.nl/Pieces.GIF
    [1, 2, 5, 6, 11],  # F
    [0, 1, 2, 3, 4],   # I or straight-5
    [0, 1, 2, 3, 5],   # L
    [0, 1, 2, 7, 8],   # N
    [0, 1, 2, 5, 6],   # P
    [0, 1, 2, 6, 11],  # big T
    [0, 1, 2, 5, 7],   # U
    [0, 1, 2, 5, 10],  # V, or big angle
    [1, 2, 5, 6, 10],  # W
    [1, 5, 6, 7, 11],  # X
    [0, 1, 2, 3, 6],   # Y
    [1, 2, 6, 10, 11], # Z
  ]

  def all do
    @pentominos
  end
  
  def index_to_xy(index) do
      [x, y] = [Integer.mod(index, @max_dimension), Integer.floor_div(index, @max_dimension)]
  end
  
  def xy_to_index(x, y) do
    x + @max_dimension * y
  end
  
  def flip_top_to_bottom(pentomino) do
    Enum.map(pentomino, fn(index) ->
      [x, y] = index_to_xy(index)
      xy_to_index(x, @max_dimension - 1 - y)
    end)
  end
  
  def flip_side_to_side(pentomino) do
    Enum.map(pentomino, fn(index) ->
      [x, y] = index_to_xy(index)
      xy_to_index(@max_dimension - 1 - x, y)
    end)
  end
  
  def rotate_left(pentomino) do
    Enum.map(pentomino, fn(index) ->
      [x, y] = index_to_xy(index)
      xy_to_index(y, @max_dimension - 1 - x)
    end)
  end
  
  def rotate_right(pentomino) do
    pentomino |> rotate_left |> rotate_left |> rotate_left
  end
  
  # Drawing with text will likely never be needed, but is handy for debugging
  def draw(pentomino, color \\ "x") do
    Enum.each(@all_indices, fn(row) ->
      Enum.map(row, fn(index) -> if index in pentomino do color else " " end end)
      |> IO.puts
    end )
  end
  def drawl(color \\ "x") do
    Enum.each(@pentominos, fn(pentomino) -> draw(pentomino, color) end)
  end
  
end
