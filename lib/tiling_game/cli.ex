
defmodule Cli do
  alias TilingGame.Pentomino
  alias TilingGame.Board
  
  def main() do
    IO.puts("Welcome to the Tiling Game!")
    print_help_message()
    
    {:ok, board} = Board.new(10, 12)
    {:ok, pentomino} = Pentomino.piece(3)
    state = %{board: board, piece_index: 17, pentomino: pentomino, color: "R"}
    
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
    "place X Y" => "Places the piece at X,Y"
    # TODO: "undo" => "Take back the most recent command"
  }

  defp receive_command(state = %{board: board, pentomino: pentomino, color: color}) do
    Board.draw(board)
    Pentomino.draw(pentomino, color)

    [command | args] =
      IO.gets("> ")
      |> String.trim
      |> String.split

    # when implementing undo, just add to command stack and replay all commands
    # (and move the receive_command() recursion to here - except for "quit")
    execute_command([String.downcase(command) | args], state)
  end

  defp execute_command(["quit"], state) do
    IO.puts "\nBye Bye!"
  end
  
  defp execute_command(["color", new_color], state = %{color: color}) do
    receive_command(%{state | color: String.upcase(new_color)})
  end
  
  defp execute_command(["piece", new_piece_index], state = %{piece_index: piece_index}) do
    new_piece_index = String.to_integer(new_piece_index)
    case Pentomino.piece(new_piece_index) do
      {:ok, pentomino} ->
        receive_command(%{state | pentomino: pentomino, piece_index: new_piece_index})
      _ ->
        IO.puts("ERROR: Pieces are numbered from 0 to 20.")
        receive_command(state)
    end
  end
  
  defp execute_command(["left"], state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.rotate_left
                |> Pentomino.snug
    
    receive_command(%{state | pentomino: pentomino})
  end
  
  defp execute_command(["right"], state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.rotate_right
                |> Pentomino.snug
    
    receive_command(%{state | pentomino: pentomino})
  end
  
  defp execute_command(["flip"], state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.flip_top_to_bottom
                |> Pentomino.snug
    
    receive_command(%{state | pentomino: pentomino})
  end
  
  defp execute_command(["swap"], state = %{pentomino: pentomino}) do
    pentomino = pentomino
                |> Pentomino.flip_side_to_side
                |> Pentomino.snug
    
    receive_command(%{state | pentomino: pentomino})
  end
  
  defp execute_command(["place", x, y], state = %{board: board, pentomino: pentomino, color: color}) do
    case Board.place_piece(board, pentomino, String.to_integer(x), String.to_integer(y), color) do
      {:ok, board} ->
        receive_command(%{state | board: board})
      {:error, message} ->
        IO.puts("ERROR: " <> message)
        receive_command(state)
    end
  end

  defp execute_command(_unknown, state) do
    IO.puts("\nInvalid command. I don't know what to do.")
    print_help_message()

    receive_command(state)
  end
  
  defp print_help_message do
    IO.puts("The game supports following commands:")
    Enum.map(@commands, fn({command, description}) ->
      IO.puts("  #{command} - #{description}")
    end)
    IO.puts("")
  end
end
