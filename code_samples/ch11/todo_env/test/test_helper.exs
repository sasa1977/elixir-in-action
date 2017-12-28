File.rm_rf!(Application.fetch_env!(:todo, :db_folder))
File.mkdir_p!(Application.fetch_env!(:todo, :db_folder))
ExUnit.start()
