# Before starting, run:
#   MIX_ENV=prod mix compile.protocols
#
# Then, to start the test:
#   MIX_ENV=prod elixir  -pa _build/prod/consolidated/  -S mix run load_test.exs

:ok = :mnesia.wait_for_tables([:todo_lists], 1000)
{:atomic, :ok} = :mnesia.clear_table(:todo_lists)


# The load test uses wrk (https://github.com/wg/wrk): a modern HTTP benchmarking tool
# capable of generating significant load when run on a single multi-core CPU.
# 
# Installation:
# - OSX: Homebrew or build from source (https://github.com/wg/wrk/wiki/Installing-wrk-on-OSX)
# - Linux: build from source (https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux)
# - Windows: not available
# 
# This runs a benchmark for 120 seconds, using 4 threads, keeping 100 HTTP connections open,
# timing out the request after 2 seconds, and evaluating wrk.lua to generate URLs.
:os.cmd('wrk -t4 -c100 -d120s --timeout 2s -s wrk.lua "http://localhost:5454"') |> IO.puts

Application.stop(:mnesia)
File.rm_rf("./Mnesia.nonode@nohost")