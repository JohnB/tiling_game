defmodule TilingGame.Game do
  alias __MODULE__
  alias TilingGame.Board

  @moduledoc """
    supposed to represent the game - duh

    Idea: switch to gen_statem
      http://erlang.org/doc/man/gen_statem.html
      http://erlang.org/doc/design_principles/statem.html
      https://potatosalad.io/2017/10/13/time-out-elixir-state-machines-versus-servers
      https://hexdocs.pm/gen_state_machine/GenStateMachine.html

    Potential states:
        waiting for players
        ready to play
        initial moves
        ongoing moves
        all players done?
        archive game

    Even cleaner abstraction with GenStateMachine:

    defmodule Switch do
      use GenStateMachine

      # Callbacks

      def handle_event(:cast, _action = :flip, _state = :off, data) do
        {:next_state, :on, data + 1}
      end

      def handle_event(:cast, _action = :flip, _state = :on, data) do
        {:next_state, :off, data}
      end

      def handle_event({:call, from}, _action = :get_count, state, data) do
        {:next_state, state, data, [{:reply, from, data}]}
      end
    end

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
