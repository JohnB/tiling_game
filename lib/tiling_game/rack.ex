defmodule TilingGame.Rack do
  #alias __MODULE__

  @moduledoc """
    Your rack is where you store your pieces before playing them.
    
    Initial positions look like this, using numbers for the smaller, non-pentomino pieces,
    and using the pentomino-_lettering_
    [from the University of Texas](https://web.ma.utexas.edu/users/smmg/archive/1997/radin.html):

    ```
    +-------------+
    |             |
    | 1 22 333 44 |
    |           4 |
    | 5555 666    |
    |      6   88 |
    | 777      88 |
    |  7  LLLL    |
    |     L    NN |
    | 99     NNN  |
    |  99 PP      |
    |     PPP VVV |
    | UUU       V |
    | U U IIIII V |
    |             |
    |  FF TTT  WW |
    | FF   T  WW  |
    |  F   T WW   |
    |    X      Z |
    | Y XXX   ZZZ |
    | Y  X    Z   |
    | YY          |
    | Y           |
    |             |
    +-------------+
    ```
  """

  # Generate this hash by running:
  #   ruby rack_hash.rb
  # and placing the output here.

end

#  {
#    '1' => [14],
#    '2' => [16, 17],
#    '3' => [19, 20, 21],
#    '4' => [23, 24, 37],
#    '5' => [40, 41, 42, 43],
#    '6' => [45, 46, 47, 58],
#    '8' => [62, 63, 75, 76],
#    '7' => [66, 67, 68, 80],
#    'L' => [83, 84, 85, 86, 96],
#    'N' => [101, 102, 112, 113, 114],
#    '9' => [105, 106, 119, 120],
#    'P' => [122, 123, 135, 136, 137],
#    'V' => [139, 140, 141, 154, 167],
#    'U' => [144, 145, 146, 157, 159],
#    'I' => [161, 162, 163, 164, 165],
#    'F' => [184, 185, 196, 197, 210],
#    'T' => [187, 188, 189, 201, 214],
#    'W' => [192, 193, 204, 205, 216, 217],
#    'X' => [225, 237, 238, 239, 251],
#    'Z' => [232, 243, 244, 245, 256],
#    'Y' => [235, 248, 261, 262, 274],
#  }
