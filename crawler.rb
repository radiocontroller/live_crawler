require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
    include Singleton

    def initialize
        @redis = Redis.new
        @logger = Logger.new("*.log")
        @agent = Mechanize.new
        @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
	      @agent.max_history = 0
    end

    def crawl_lol
      list = []

      # 斗鱼直播
      page_url = "https://www.douyu.com/directory/game/LOL"
      list << douyu_data(page_url)

      # 熊猫直播
      page_url = "http://www.panda.tv/cate/lol"
      list << xiongmao_data(page_url)

      # 虎牙直播
      page_url = "http://www.huya.com/g/lol"
      list << huya_data(page_url)

      # 龙珠直播
      page_url = "http://longzhu.com/channels/lol?from=rmgame"
      list << longzhu_data(page_url)

      # 全民tv
      page_url = "http://www.quanmin.tv/game/lol"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_LOL_KEY)
    end

    def crawl_zjgame
      list = []

      page_url = "https://www.douyu.com/directory/game/TVgame"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/zhuji"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/ZJGAME"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/djzjjj?from=topbargame"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/tvgame"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_ZJGAME_KEY)
    end

    def crawl_jdqs
      list = []

      page_url = "https://www.douyu.com/directory/game/jdqs"
      list << douyu_data(page_url)

      page_url = "https://www.panda.tv/cate/pubg"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/2793"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/jdqs?from=figame"
      list << longzhu_data(page_url)

      page_url = "https://www.quanmin.tv/game/juediqiusheng"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_JDQS_KEY)
    end

    def crawl_cf
      list = []

      page_url = "https://www.douyu.com/directory/game/CF"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/cf"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/4"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/cf?from=topbargame"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/cfpc"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CF_KEY)
    end

    def crawl_outdoor
      list = []

      page_url = "https://www.douyu.com/g_HW"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/hwzb"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/huwai"
      list << huya_data(page_url)

      # page_url = "http://longzhu.com/channels/huwai"
      # list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/huwai"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_OUTDOOR_KEY)
    end

    def crawl_lushi
      list = []

      page_url = "https://www.douyu.com/directory/game/How"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/hearthstone"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/393"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/hs"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/hearthstone"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_LUSHI_KEY)
    end

    def crawl_shouwang
      list = []

      page_url = "https://www.douyu.com/directory/game/Overwatch"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/overwatch"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/2174"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/ow"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/overwatch"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SHOUWANG_KEY)
    end

    def crawl_wangzhe
      list = []

      page_url = "https://www.douyu.com/directory/game/wzry"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/kingglory"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/2336"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/wzry"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/wangzhe"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_WANGZHE_KEY)
    end

    def crawl_speed
      list = []

      page_url = "https://www.douyu.com/directory/subCate/jingsu/396"
      list << douyu_data(page_url)

      page_url = "http://www.quanmin.tv/game/qqfeiche"
      list << quanmin_data(page_url)

      page_url = "http://www.huya.com/g/9"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/speed?from=figame"
      list << longzhu_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SPEED_KEY)
    end

    def crawl_csgo
      list = []

      page_url = "https://www.douyu.com/directory/game/CSGO"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/csgo"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/862"
      list << huya_data(page_url)

      page_url = "http://longzhu.com/channels/csgo"
      list << longzhu_data(page_url)

      page_url = "http://www.quanmin.tv/game/csgo"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CSGO_KEY)
    end

    def crawl_chess
      list = []

      page_url = "https://www.douyu.com/directory/game/qipai"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/qipai"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/100036"
      list << huya_data(page_url)

      page_url = "http://www.quanmin.tv/game/qipai"
      list << quanmin_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CHESS_KEY)
    end

    def crawl_movie
      list = []

      page_url = "https://www.douyu.com/directory/game/stdp"
      list << douyu_data(page_url)

      page_url = "http://www.panda.tv/cate/cartoon"
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/seeTogether"
      list << huya_data(page_url)

      page_url = "http://www.quanmin.tv/game/dzh"
      list << quanmin_data(page_url)

      page_url = "http://longzhu.com/channels/movie"
      list << longzhu_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_MOVIE_KEY)
    end

    def crawl_show
      list = []

      page_url = "https://www.douyu.com/directory/game/xingyu"
      list << douyu_data(page_url)

      page_url = "https://www.douyu.com/directory/game/music"  # 音乐
      list << douyu_data(page_url)

      page_url = "https://www.panda.tv/cate/yzdr"
      list << xiongmao_data(page_url)

      page_url = "https://www.panda.tv/cate/music"  # 音乐
      list << xiongmao_data(page_url)

      page_url = "http://www.huya.com/g/xingxiu"
      list << huya_data(page_url)

      # page_url = "https://www.quanmin.tv/game/showing"
      # list << quanmin_data(page_url)

      # page_url = "http://longzhu.com/channels/lzxx"
      # list << longzhu_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SHOW_KEY)
    end

    def crawl_ninja
      list = []

      page_url = "https://chushou.tv/nav-list.htm?targetKey=3-1674-3"
      list << chushou_data(page_url)

      page_url = "http://www.huya.com/g/4041?promoter=huya_web_205"
      list << huya_data(page_url)

      page_url = "https://www.douyu.com/g_rzbxs3"
      list << douyu_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_NINJA_KEY)
    end

    private

        # 在线人数字符串转浮点型
        def convert_float(num)
            base = 1
            if num.include?("万人")
                num.gsub!("万人", "")
                base = 10_000
            elsif num.include?("万")
                num.gsub!("万", "")
                base = 10_000
            end
            num.to_f * base
        end

        def douyu_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#live-list-contentbox li")
            lives.map do |live|
                {
                    "detail" => {
                        url: File.join("https://www.douyu.com", live.search("a").attr("href").text),
                        img_url: live.search("img").last.attr("data-original"),
                        name: live.search("span.dy-name").text,
                        title: live.search("h3.ellipsis").text.strip,
                        platform: "斗鱼"
                    },
                    "num" => live.search("span.dy-num").text
                }
            end
        rescue => e
            exception_log(e, "斗鱼直播: #{page_url}")
            []
        end

        def xiongmao_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul#sortdetail-container li.video-no-tag")
            lives.map do |live|
                {
                    "detail" => {
                        url: File.join("http://www.panda.tv", live.search("a").attr("href").text),
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("span.video-nickname").text.strip,
                        title: live.search("span.video-title").text.strip,
                        platform: "熊猫"
                    },
                    "num" => live.search("span.video-number").text
                }
            end
        rescue => e
            exception_log(e, "熊猫直播: #{page_url}")
            []
        end

        def huya_data(page_url)
            page = @agent.get(page_url)
	          lives = page.search("ul#js-live-list li")
            lives.map do |live|
                {
                    "detail" => {
                        url: live.search("a").attr("href").text,
                        img_url: live.search("img").attr("data-original").text,
                        name: live.search("i.nick").text,
                        title: live.search("a.title").children[0].text.strip,
                        platform: "虎牙"
                    },
                    "num" => live.search("i.js-num").text
                }
            end
        rescue => e
            exception_log(e, "虎牙直播: #{page_url}")
            []
        end

        def zhanqi_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("ul.js-room-list-ul li")
            lives.map do |live|
                {
                    "detail" => {
                        url: File.join("http://www.zhanqi.tv", live.search("a").attr("href").text),
                        img_url: live.search("img").first.attributes["src"].value,
                        name: live.search("span.anchor").text,
                        title: live.search("span.name").text.strip,
                        platform: "战旗"
                    },
                    "num" => live.search("span.dv").first.text
                }
            end
        rescue => e
            exception_log(e, "战旗直播: #{page_url}")
            []
        end

        def longzhu_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("a.livecard")
            lives.map do |live|
                {
                    "detail" => {
                        url: "http:" + live.attributes["href"].value,
                        img_url: live.search("img")[0].attributes["src"].value,
                        name: live.search("strong.livecard-modal-username")[0].children.text,
                        title: live.search("h3.listcard-caption").children.text.strip,
                        platform: "龙珠"
                    },
                    "num" => live.search("span.livecard-meta-item-text").children[0].text
                }
            end
        rescue => e
            exception_log(e, "龙珠直播: #{page_url}")
            []
        end

        def quanmin_data(page_url)
            page = @agent.get(page_url)
            lives = page.search("li.list_w-video")
            lives.map do |live|
                {
                    "detail" => {
                        url: File.join("http://www.quanmin.tv", live.search("a.common_w-card_href")[0].attributes["href"].value.split(".tv").last),
                        img_url: live.search("img.common_w-card_cover")[0].attributes["src"].value,
                        name: live.search("span.common_w-card_host-name")[0].children.text,
                        title: live.search("p.common_w-card_title")[0].children.text.strip,
                        platform: "全民"
                    },
                    "num" => live.search("span.common_w-card_views-num")[0].children.text
                }
            end
        rescue => e
            exception_log(e, "全名直播: #{page_url}")
            []
        end

        def chushou_data(page_url)
          page = @agent.get(page_url)
          lives = page.search("div#liveContent a")
          lives.map do |live|
              {
                  "detail" => {
                      url: File.join("https://chushou.tv", live.attributes["href"].value),
                      img_url: live.search("img.liveImages")[0].attributes["data-imgsrc"].value,
                      name: live.search("span.livePlayerName")[0].attributes["title"].value,
                      title: live.search("span.videoName")[0].attributes["title"].value,
                      platform: "触手"
                  },
                  "num" => live.search("span.liveCount")[0].children[0].text
              }
          end
        rescue => e
            exception_log(e, "触手直播: #{page_url}")
            []
        end

        def update_lives(list, cache_key)
            @redis.del cache_key
            list.each do |data|
                @redis.zadd(cache_key, convert_float(data["num"]), JSON.generate(data["detail"]))
            end
        end

        def exception_log(e, game)
            @logger.info("----- #{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')} 抓取#{game}异常 -----")
            @logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        end
end
