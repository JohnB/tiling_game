defmodule GameStateMachine do
  alias __MODULE__
  use GenStateMachine

  @moduledoc """
    supposed to represent the game - duh

    # Start the server
    initial_state = :undefined
    data = %{} # this is the *actual* state
    {:ok, pid} = GenStateMachine.start_link(GameStateMachine, {initial_state, data})

    # This is the client
    GenStateMachine.cast(pid, :create_game)

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

  """

  # Callbacks

  def handle_event(:cast, :create_game, :undefined, data) do
    {:next_state, :started, %{player_ids: [], num_players: 0}}
  end

  def handle_event(:cast, _action = :place_piece, _state = :started, data) do
    {:next_state, :off, data}
  end

  def handle_event({:call, from}, _action = :get_count, state, data) do
    {:next_state, state, data, [{:reply, from, data}]}
  end
end
