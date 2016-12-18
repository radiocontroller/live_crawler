require './crawler'

namespace :crawler do

  desc "crawl live video"
  task :crawl do
      Crawler.instance.crawl_lol
  end

end
