# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'crawler_with_sinatra'
set :repo_url, 'git@github.com:radiocontroller/crawler_with_sinatra.git'
set :deploy_to, '/home/ubuntu/www/crawler_with_sinatra'
set :deploy_user, 'ubuntu'
set :scm, :git
set :format, :pretty
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets tmp/log vendor/bundle}

# Default value for keep_releases is 5
set :keep_releases, 5

set :rvm_type, :system
set :rvm_ruby_string, '2.2.3'
set :rvm_roles, [:app, :web, :db]
set :rvm_custom_path, '/home/ubuntu/.rvm'
set :whenever_identifier, ->{ "#{fetch(:application)}}" }

namespace :deploy do

  after :restart, :'puma:restart'    #添加此项重启puma
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
