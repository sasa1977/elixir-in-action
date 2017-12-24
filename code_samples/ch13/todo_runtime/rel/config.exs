Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: :prod

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :todo
end

release :todo do
  set version: current_version(:todo)
  set applications: [:runtime_tools]
end
