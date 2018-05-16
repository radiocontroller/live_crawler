set :output, '/crawler_with_sinatra/log/cron.log'
set :bundle_command, "/usr/local/bundle/bin/bundle exec"
every 2.minutes do
  rake "crawler:crawl_all"
end
