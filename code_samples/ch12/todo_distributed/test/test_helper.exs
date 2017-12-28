File.rm_rf!(Application.fetch_env!(:todo, :db_folder))
File.mkdir_p!(Path.join(Application.fetch_env!(:todo, :db_folder), "nonode"))
ExUnit.start()
