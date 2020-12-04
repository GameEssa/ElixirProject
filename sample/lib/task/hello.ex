defmodule Mix.Tasks.Hello do
  use Mix.Task


  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    Mix.Task.run("app.start")

    Sample.say()
  end
end
