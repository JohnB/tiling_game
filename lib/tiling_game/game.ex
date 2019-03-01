defmodule TilingGame.Game do
  alias __MODULE__
  alias TilingGame.Board

  @moduledoc """
    supposed to represent the game - duh

    Idea: switch to gen_statem
      http://erlang.org/doc/man/gen_statem.html
      http://erlang.org/doc/design_principles/statem.html
      https://potatosalad.io/2017/10/13/time-out-elixir-state-machines-versus-servers

    Potential states:
        waiting for players
        ready to play
        initial moves
        ongoing moves
        all players done?
        archive game

  """

  defstruct [:board, :players, :start_style]

  @player_range 2..4
  @start_styles [:standard, :random]

  def new(%{players: players}) when not (players in @player_range),
    do: {:error, :invalid_number_of_players}

  def new(%{start: start_style}) when not (start_style in @start_styles),
    do: {:error, :unknown_style}

  def new(%{width: width, height: height, players: players, start: start_style}) do
    {:ok, board} = Board.new(width, height)
    {:ok, %Game{board: board, players: players, start_style: start_style}}
  end
end
