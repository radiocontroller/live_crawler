require './crawler'

namespace :crawler do

  desc "crawl all live videos"
  task :crawl_all do
      Crawler.instance.crawl_lol
      Crawler.instance.crawl_zjgame
      Crawler.instance.crawl_cf
      Crawler.instance.crawl_lushi
      Crawler.instance.crawl_shouwang
      Crawler.instance.crawl_wangzhe
      Crawler.instance.crawl_dota2
      Crawler.instance.crawl_csgo
  end
end
