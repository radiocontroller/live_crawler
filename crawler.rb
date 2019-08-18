require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
    include Singleton
    DOUYU = 'https://www.douyu.com'
    HUYA = 'https://www.huya.com'
    CHUSHOU = 'https://chushou.tv'
    QIE = 'https://egame.qq.com'

    def initialize
      @redis = Redis.new
      @logger = Logger.new("*.log")
      @agent = Mechanize.new
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
	    @agent.max_history = 0
      @agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36'
    end

    def crawl_lol
      list = []

      page_url = "#{DOUYU}/g_LOL"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/lol"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=lol"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_LOL_KEY)
    end

    def crawl_zjgame
      list = []

      page_url = "#{DOUYU}/g_TVgame"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/ZJGAME"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000140"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_ZJGAME_KEY)
    end

    def crawl_jdqs
      list = []

      page_url = "#{DOUYU}/g_jdqs"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/2793"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000133"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_JDQS_KEY)
    end

    def crawl_cf
      list = []

      page_url = "#{DOUYU}/g_CF"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/4"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=Cf"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CF_KEY)
    end

    def crawl_outdoor
      list = []

      page_url = "#{DOUYU}/g_HW"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/huwai"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=40000001470"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_OUTDOOR_KEY)
    end

    def crawl_lushi
      list = []

      page_url = "#{DOUYU}/g_How"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/393"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000105"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_LUSHI_KEY)
    end

    def crawl_shouwang
      list = []

      page_url = "#{DOUYU}/g_Overwatch"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/2174"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000107"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SHOUWANG_KEY)
    end

    def crawl_wangzhe
      list = []

      page_url = "#{DOUYU}/g_wzry"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/2336"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=1104466820"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_WANGZHE_KEY)
    end

    def crawl_speed
      list = []

      page_url = "#{HUYA}/g/9"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=QQfc"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SPEED_KEY)
    end

    def crawl_csgo
      list = []

      page_url = "#{DOUYU}/g_CSGO"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/862"
      list << huya_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CSGO_KEY)
    end

    def crawl_chess
      list = []

      page_url = "#{DOUYU}/g_qipai"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/100036"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000008"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_CHESS_KEY)
    end

    def crawl_movie
      list = []

      page_url = "#{DOUYU}/g_stdp"
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/seeTogether"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=2000000110"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_MOVIE_KEY)
    end

    def crawl_show
      list = []

      page_url = "#{DOUYU}/g_xingyu"
      list << douyu_data(page_url)

      page_url = "#{DOUYU}/directory/game/music"  # 音乐
      list << douyu_data(page_url)

      page_url = "#{HUYA}/g/xingxiu"
      list << huya_data(page_url)

      page_url = "#{QIE}/livelist?layoutid=40000001472"
      list << qie_data(page_url)

      list.flatten!

      update_lives(list, App::LIVE_SHOW_KEY)
    end

    def crawl_ninja
      list = []

      page_url = "#{CHUSHOU}/nav-list.htm?targetKey=3-1674-3"
      list << chushou_data(page_url)

      page_url = "#{HUYA}/g/4041?promoter=huya_web_205"
      list << huya_data(page_url)

      page_url = "#{DOUYU}/g_rzbxs3"
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
            text = page.search("script")[4].children[0].text
            lives = JSON.parse("{#{text.scan(/[^{]*\{(.*)/)[0][0].chop}")["list"]
            lives.map do |live|
                {
                    "detail" => {
                        url: File.join("#{DOUYU}", live["url"]),
                        img_url: live["rs1"],
                        name: live["nn"],
                        title: live["rn"],
                        platform: "斗鱼"
                    },
                    "num" => live["ol"].to_s
                }
            end
        rescue => e
            exception_log(e, "斗鱼直播: #{page_url}")
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

        def chushou_data(page_url)
          page = @agent.get(page_url)
          lives = page.search("div#liveContent a")
          lives.map do |live|
              {
                  "detail" => {
                      url: File.join(CHUSHOU, live.attributes["href"].value),
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

        def qie_data(page_url)
          page = @agent.get(page_url)
          lives = page.search("li.gui-list-normal a")
          lives.map do |live|
              {
                  "detail" => {
                      url: File.join(QIE, live.attributes["href"].value),
                      img_url: live.search('div.content').search('img')[-1].attributes['src'].value,
                      name: live.search('p.name')[0].children[0].text,
                      title: live.search('h4')[0].children[0].text,
                      platform: "企鹅"
                  },
                  "num" => live.search('span.popular').text.gsub(/\s/, '')
              }
          end
        rescue => e
            exception_log(e, "企鹅直播: #{page_url}")
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
