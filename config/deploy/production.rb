server '123.206.177.20', user: 'ubuntu', roles: %w{web app db}, primary: true, port: 22
set :stage, :production
set :branch, :master
set :rails_env, :production
set :deploy_to, '/home/ubuntu/www/crawler_with_sinatra'
set :rvm_type, :system
set :rvm_ruby_version , '2.2.3'

# PUMA
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,   "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix:///tmp/crawler_with_sinatra.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [2, 4]
set :puma_workers, 1
