#! /usr/bin/env elixir

defmodule EIA.TestRunner do
  def run do
    [&check_elixir_version/0, &test_scripts/0, &test_projects/0]
    |> run_while_ok
    |> print_result
  end

  defp run_while_ok(commands) do
    Enum.reduce(commands, :ok, &execute_command/2)
  end

  defp execute_command(fun, :ok), do: fun.()
  defp execute_command(_, error), do: error

  defp print_result(:ok), do: IO.puts("\nDone!\n")

  defp print_result({:error, error}) do
    IO.puts(:standard_error, "\nError:\n\n#{error}\n")
    System.halt(1)
  end

  defp check_elixir_version(project_root \\ ".") do
    case System.cmd("elixir", ["-v"], cd: project_root, stderr_to_stdout: true) do
      {elixir_version, 0} ->
        if elixir_version =~ ~r/^Elixir 1\.\d\.\d+/m do
          :ok
        else
          {:error, "Invalid Elixir version #{elixir_version}"}
        end

      {error, _} ->
        {:error, error}
    end
  end

  defp test_scripts do
    Path.wildcard("./ch??/**/test/tests.exs")
    |> Stream.flat_map(&file_commands/1)
    |> run_while_ok
  end

  defp file_commands(test_file) do
    [
      &IO.puts("Testing #{&1}"),
      &run_test_script/1
    ]
    |> Enum.map(&fn -> apply(&1, [test_file]) end)
  end

  defp run_test_script(test_file) do
    System.cmd("elixir", [test_file], stderr_to_stdout: true)
    |> cmd_result
  end

  defp test_projects do
    Path.wildcard("./ch??/*/mix.exs")
    |> Stream.map(&Path.dirname/1)
    |> Stream.flat_map(&project_commands(&1))
    |> run_while_ok
  end

  defp project_commands(project_root) do
    [
      &IO.puts("\nTesting #{&1}"),
      &check_elixir_version/1,
      &run_mix(&1, "deps.get"),
      &run_mix(&1, "test")
    ]
    |> Enum.map(&fn -> apply(&1, [project_root]) end)
  end

  defp run_mix(project_root, mix_cmd) do
    IO.puts("  mix #{mix_cmd}...")

    System.cmd("mix", [mix_cmd], cd: project_root, stderr_to_stdout: true)
    |> cmd_result
  end

  defp cmd_result({_, 0}), do: :ok
  defp cmd_result({error, _}), do: {:error, error}
end

EIA.TestRunner.run()
