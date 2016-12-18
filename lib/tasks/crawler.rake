require './crawler'

namespace :crawler do

  desc "crawl lol live video"
  task :crawl_lol do
      Crawler.instance.crawl_lol
  end

  desc "crawl lushi live video"
  task :crawl_lushi do
      Crawler.instance.crawl_lushi
  end

end
