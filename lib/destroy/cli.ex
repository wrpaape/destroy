defmodule Destroy.CLI do
  @parse_opts [
      switches:
        [
          help: :boolean
        ],
      aliases:
        [
          h: :help
        ]
    ]

  def main(argv) do
    argv
    |> parse_args
    |> process_args
    |> Destroy.generation
  end

  def process_args(:help) do
    """
    usage: destroy [<gen_type> | html] <Resource (capitalized CamelCase)> <resources (pluralized snake_case)>
    """
    |> IO.puts

    System.halt(0)
  end

  def process_args([:html | [singular | _rest]]), do: {:html, singular}

  def parse_args(argv) do
    argv
    |> OptionParser.parse(@parse_opts)
    |> IO.inspect
    |> case do
      {[ help: true ], _, _}           -> :help

      {_, [type, singular, plural], _} -> [String.to_atom(type), singular, plural]
      
      {_, [singular, _plural], _}      -> [:html, singular]

      {_, [singular], _}               -> [:html, singular]
      
                                     _ -> :help
    end
  end
end
