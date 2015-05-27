# Before starting, run:
#   MIX_ENV=prod mix compile.protocols
#
# Then, to start the test:
#   MIX_ENV=prod elixir  -pa _build/prod/consolidated/  -S mix run load_test.exs

:ok = :mnesia.wait_for_tables([:todo_lists], 1000)
{:atomic, :ok} = :mnesia.clear_table(:todo_lists)

:os.cmd('wrk -t4 -c100 -d120s --timeout 2000 -s wrk.lua "http://localhost:5454"') |> IO.puts

Application.stop(:mnesia)
File.rm_rf("./Mnesia.nonode@nohost")