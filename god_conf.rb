God.pid_file_directory = "#{ENV["HOME"]}/.sakadasan_pids"
app_root = "#{ENV["HOME"]}/sakadasan"

God.watch do |w|
  w.name = "sakadasan/tuple_space.rb"
  w.start = "cd #{app_root}; ./tuple_space.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/pull.rb"
  w.start = "cd #{app_root}; ./pull.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/invent.rb"
  w.start = "cd #{app_root}; ./invent.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/read.rb"
  w.start = "cd #{app_root}; ./read.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/push_tweet.rb"
  w.start = "cd #{app_root}; ./push_tweet.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/tweet.rb"
  w.start = "cd #{app_root}; ./tweet.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/reply.rb"
  w.start = "cd #{app_root}; ./reply.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/update.rb"
  w.start = "cd #{app_root}; ./update.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/push_adjust.rb"
  w.start = "cd #{app_root}; ./push_adjust.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end

God.watch do |w|
  w.name = "sakadasan/adjust.rb"
  w.start = "cd #{app_root}; ./adjust.rb"
  w.behavior(:clean_pid_file)
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 3.seconds
      c.running = false
    end
  end
end
