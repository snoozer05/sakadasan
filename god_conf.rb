God.pid_file_directory = "#{ENV["HOME"]}/.sakadasan_pids"
app_root = "#{ENV["HOME"]}/sakadasan"
system("cd #{app_root}")

God.watch do |w|
  w.name = "tuple_space.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/tuple_space.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "pull.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/pull.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "invent.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/invent.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "record.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/record.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "read.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/read.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "update.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/update.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "push_adjust.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/push_adjust.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "adjust.rb"
  w.group = "sakadasan"
  w.dir = app_root
  w.start = "#{app_root}/adjust.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end
