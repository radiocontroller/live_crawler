require './crawler'

namespace :crawler do

  desc "crawl all live videos"
  task :crawl_all do
      pid_file = File.expand_path('../../crawler.pid', File.dirname(__FILE__))
      File.new(pid_file, "w") { f.puts Process.pid } if !File.exists? pid_file

      Crawler.instance.crawl_lol
      Crawler.instance.crawl_zjgame
      Crawler.instance.crawl_jdqs
      Crawler.instance.crawl_cf
      Crawler.instance.crawl_outdoor
      Crawler.instance.crawl_lushi
      Crawler.instance.crawl_shouwang
      Crawler.instance.crawl_wangzhe
      Crawler.instance.crawl_speed
      Crawler.instance.crawl_csgo
      Crawler.instance.crawl_chess
      Crawler.instance.crawl_movie
      Crawler.instance.crawl_ninja
      Crawler.instance.crawl_show

      File.delete(pid_file) if File.exists? pid_file
  end
end
