require './crawler'

namespace :crawler do

  desc "crawl douyu video!!"
  task :crawl do
      Crawler.instance.execute
  end

end
