defmodule TilingGame.Board do
  alias __MODULE__

  @enforce_keys [:width, :height]
  defstruct [:width, :height]

  @width_range 10..30
  @height_range 10..35

  def new(width, height) when not(width in(@width_range) and height in(@height_range)), do:
    {:error, :invalid_board}
    
  def new(width, height), do:
    {:ok, %Board{width: width, height: height}}
    
end
