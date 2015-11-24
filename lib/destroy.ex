defmodule Destroy do
  @message IO.ANSI.bright
    <> IO.ANSI.red
    <> "* destroying "
    <> IO.ANSI.normal
    <> IO.ANSI.white

  def generation({:html, singular}) do
    ~w[
      web/controllers/#{singular}_controller.ex
      web/templates/#{singular}
      web/views/#{singular}_view.ex
      test/controllers/#{singular}_controller_test.exs
      priv/repo/migrations/??????????????_create_#{singular}.exs
      web/models/#{singular}.ex
      test/models/#{singular}_test.exs
    ]
    |> Enum.flat_map(&Path.wildcard/1)
    |> Enum.each(fn(path) ->
      IO.puts @message <> path
      File.rm_rf(path)
    end)
  end
end
