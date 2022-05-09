# frozen_string_literal: true

set :output, '/live_crawler/log/cron.log'
ENV.each { |k, v| env(k, v) }

every 2.minutes do
  rake 'crawler:crawl_all'
end
