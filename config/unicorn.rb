require 'dotenv'

worker_processes ENV.fetch('UNICORN_WORKERS', 2).to_i
preload_app true

stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

listen '127.0.0.1:8080'
timeout 30
pid "tmp/pids/unicorn.pid"

before_exec do |server|
  ENV.update Dotenv::Environment.new('.env')
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
