use Mix.Config

config :todo, db_folder: "./persist"
config :todo, port: 5454

import_config "#{Mix.env()}.exs"
