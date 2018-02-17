use Mix.Releases.Config, default_environment: :prod

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :todo)
end

release :todo do
  set(version: current_version(:todo))
end
