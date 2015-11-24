defmodule Destroy do
  @message
    IO.ANSI.bright
    <> IO.ANSI.red
    <> "* destroying "
    <> IO.ANSI.normal
    <> IO.ANSI.white

  @parse_opts
  [
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
    |> destroy_generated
  end

  def process_args(:help) do
    """
    usage: destroy [<gen_type> | html] <Resource (capitalized CamelCase)> <resources (pluralized snake_case)>
    """
    |> IO.puts

    System.halt(0)
  end

  def process_args([:html | [singular | _rest]]) do
    destroy_generated(:html, singular)
  end


  def parse_args(argv) do
    parse = OptionParser.parse(argv, @parse_opts)

    case parse do
      {[ help: true ], _, _}           -> :help

      {_, [type, singular, plural], _} -> [String.to_atom(type), singular, plural]
      
      {_, [singular, _plural], _}      -> [:html, singular]

      {_, [singular], _}               -> [:html, singular]
      
                                     _ -> :help
    end
  end

  def destroy_generated(:html, singular) do
    ~w[
      web/controllers/#{singular}_controller.ex
      web/templates/#{singular}
      web/views/#{singular}_view.ex
      test/controllers/#{singular}_controller_test.exs
      priv/repo/migrations/??????????????_create_#{singular}.exs
      web/models/#{singular}.ex
      test/models/#{singular}_test.exs
    ]
    |> Enum.flat_map(&Path.wild_card/1)
    |> Enum.each(fn(path) ->
      IO.puts @message <> path
      File.rm_rf(path)
    end)
  end
end
