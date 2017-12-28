File.rm_rf!("./persist")
File.mkdir_p!("./persist")
Todo.System.start_link()
ExUnit.start()
