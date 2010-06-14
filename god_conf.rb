project_name = "sakadasan"
processes = %w|tuple_space pull invent record read update push_adjust adjust|

God.pid_file_directory = "#{ENV["HOME"]}/.#{project_name}_pids"
app_root = "#{ENV["HOME"]}/#{project_name}"

processes.each do |process|
  God.watch do |w|
    w.name = "#{process}.rb"
    w.group = project_name
    w.dir = app_root
    w.start = "#{app_root}/#{process}.rb"
    w.behavior(:clean_pid_file)
    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 3.seconds
        c.running = false
      end
    end
  end
end
