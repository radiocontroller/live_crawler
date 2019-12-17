# frozen_string_literal: true

require './crawler'

namespace :crawler do

  desc 'crawl all live videos'
  task :crawl_all do
    YAML.load_file('yml/url.yml').each do |kind, params|
      Crawler.instance.send("crawl_#{kind}", params)
    end
  end
end