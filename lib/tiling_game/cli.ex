
defmodule Cli do
  alias TilingGame.Pentomino
  alias TilingGame.Board
  
  def main() do
    IO.puts("Welcome to the Tiling Game!")
    print_help_message()
    
    {:ok, board} = Board.new(10, 12)
    {:ok, pentomino} = Pentomino.piece(3)
    state = %{
        commands: [["piece", ["3"]], ["color", ["R"]]],
        board: board,
        piece_index: 17,
        pentomino: pentomino,
        color: "R"
      }
    
    receive_command(state)
  end

  @commands %{
    "quit" => "Quits the game",
    "color C" => "Select color C (R, Y, G, B)",
    "piece X" => "Select piece X (0-20)",
    "left" => "Left rotate",
    "right" => "Right rotate",
    "flip" => "Flip the piece top to bottom",
    "swap" => "Flip the piece left to right",
    "place X Y" => "Places the piece at X,Y",
    "undo" => "Take back the most recent command"
  }

  defp receive_command(state = %{board: board, pentomino: pentomino, color: color}) do
    state = replay_commands(state)
    Board.draw(board)
    IO.puts("")
    Pentomino.draw(pentomino, color)
    [command | args] = get_command_from_user()
    
    # when implementing undo, just add to command stack and replay all commands
    # (and move the receive_command() recursion to here - except for "quit")
    case execute_command(command, args, state) do
      {:ok, state} ->
        cmds = case command do
          "undo" ->
            state[:commands]
          _ ->
            [[command, args] | state[:commands]]
        end
        
        receive_command(%{state | commands: cmds})
      _ ->
        IO.puts("\nB'bye!")
    end
  end
  
  defp get_command_from_user do
    case IO.gets("> ") |> String.trim |> String.split do
      [] ->
        IO.puts("--> use 'quit' to end the game")
        get_command_from_user
      [command | args] ->
        [String.downcase(command) | args]
    end
  end
  
  defp replay_commands(state = %{commands: commands}) do
    {:ok, board} = Board.new(10, 12)
    {:ok, pentomino} = Pentomino.piece(3)
    state = %{state | board: board, pentomino: pentomino}
    
    commands
    |> Enum.reverse
    |> Enum.reduce(state, fn (cmd, acc) ->
      [command, args] = cmd
      {:ok, acc} = execute_command(command, args, acc)
      acc
    end)
  end

  defp execute_command("quit", _args, state) do
    IO.puts "\nBye Bye!"
    {:quit, state}
  end
  
  defp execute_command("color", args, state) do
    [new_color | _] = args
    {:ok, %{state | color: String.upcase(new_color)}}
  end
  
  defp execute_command("piece", args, state = %{piece_index: piece_index}) do
    [new_piece_index | _] = args
    new_piece_index = String.to_integer(new_piece_index)
    case Pentomino.piece(new_piece_index) do
      {:ok, pentomino} ->
        {:ok, %{state | pentomino: pentomino, piece_index: new_piece_index}}
      _ ->
        IO.puts("ERROR: Pieces are numbered from 0 to 20.")
        {:ok, state}
    end
  end
  
  defp execute_command("left", _args, state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.rotate_left
                |> Pentomino.snug
    
    {:ok, %{state | pentomino: pentomino}}
  end
  
  defp execute_command("right", _args, state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.rotate_right
                |> Pentomino.snug
    
    {:ok, %{state | pentomino: pentomino}}
  end
  
  defp execute_command("flip", _args, state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.flip_top_to_bottom
                |> Pentomino.snug
    
    {:ok, %{state | pentomino: pentomino}}
  end
  
  defp execute_command("swap", _args, state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.flip_side_to_side
                |> Pentomino.snug
    
    {:ok, %{state | pentomino: pentomino}}
  end
  
  defp execute_command("place", [x, y], state = %{board: board, pentomino: pentomino, color: color}) do
    case Board.place_piece(board, pentomino, String.to_integer(x), String.to_integer(y), color) do
      {:ok, board} ->
        {:ok, %{state | board: board}}
      {:error, message} ->
        IO.puts("ERROR: " <> message)
        {:ok, state}
    end
  end
  
  defp execute_command("undo", args, state = %{commands: [_ | []]}) do
    {:ok, %{state | commands: [["piece", ["3"]], ["color", ["R"]]]}}
  end
  defp execute_command("undo", args, state = %{commands: [_ | commands]}) do
    {:ok, %{state | commands: commands}}
  end

  defp execute_command(unknown, args, state) do
    IO.puts("\nInvalid command (" <> inspect([unknown, args]) <> "). I don't know what to do.")
    print_help_message()
    {:ok, state}
  end
  
  defp print_help_message do
    IO.puts("The game supports following commands:")
    Enum.map(@commands, fn({command, description}) ->
      IO.puts("  #{command} - #{description}")
    end)
    IO.puts("")
  end
end
