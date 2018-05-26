defmodule TilingGame.Game do
  alias __MODULE__
  alias TilingGame.Board

  defstruct [:board, :players, :start_style]
  
  @player_range 2..4
  @start_styles [:standard, :random]
  
  def new(%{players: players}) when not(players in @player_range), do: {:error, :invalid_number_of_players}
  def new(%{start: start_style}) when not (start_style in @start_styles), do: {:error, :unknown_style}
  
  def new(%{width: width, height: height, players: players, start: start_style}) do
    {:ok, %Game{board: Board.new(width, height), players: players, start_style: start_style}}
  end
end
