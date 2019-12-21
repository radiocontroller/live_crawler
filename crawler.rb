# frozen_string_literal: true

require 'mechanize'
require 'singleton'
require 'redis'
require 'json'
require './app'

class Crawler
  include Singleton

  def initialize
    @agent = Mechanize.new
    @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @agent.max_history = 0
    @agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36'
    @logger = Logger.new('*.log')
  end

  # crawl_lol
  # params { douyu: url1, huya: url2, qie: url3 }
  App::KINDS.each do |kind, cache_key|
    define_method "crawl_#{kind}" do |params|
      list = params.map do |platform, relative_url|
        send("#{platform}_data", File.join(App::DOMAINS[platform.to_sym], relative_url))
      end
      update_lives(list.flatten, cache_key)
    end
  end

  def convert_float(num)
    base = 1
    if num.include?('万人')
      num.gsub!('万人', '')
      base = 10_000
    elsif num.include?('万')
      num.gsub!('万', '')
      base = 10_000
    end
    num.to_f * base
  end

  def douyu_data(page_url)
    kind = 'douyu'
    page = @agent.get(page_url)
    text = page.search('script')[4].children[0].text
    lives = JSON.parse("{#{text.scan(/[^{]*\{(.*)/)[0][0].chop}")['list']
    lives.map do |live|
      {
        'detail' => {
          url: File.join(App::DOMAINS[kind.to_sym], live['url']),
          img_url: live['rs1'],
          name: live['nn'],
          title: live['rn'],
          platform: App::PLATFORMS[kind.to_sym]
        },
        'num' => live['ol'].to_s
      }
    end
  rescue StandardError => e
    exception_log(e, "#{App::PLATFORMS[kind.to_sym]}: #{page_url}")
    []
  end

  def huya_data(page_url)
    kind = 'huya'
    page = @agent.get(page_url)
    lives = page.search('ul#js-live-list li')
    lives.map do |live|
      {
        'detail' => {
          url: live.search('a').attr('href').text,
          img_url: live.search('img').attr('data-original').text,
          name: live.search('i.nick').text,
          title: live.search('a.title').children[0].text.strip,
          platform: App::PLATFORMS[kind.to_sym]
        },
        'num' => live.search('i.js-num').text
      }
    end
  rescue StandardError => e
    exception_log(e, "#{App::PLATFORMS[kind.to_sym]}: #{page_url}")
    []
  end

  def qie_data(page_url)
    kind = 'qie'
    page = @agent.get(page_url)
    lives = page.search('li.gui-list-normal a')
    lives.map do |live|
      {
        'detail' => {
          url: File.join(App::DOMAINS[kind.to_sym], live.attributes['href'].value),
          img_url: live.search('div.content').search('img')[-1].attributes['src'].value,
          name: live.search('p.name')[0].children[0].text,
          title: live.search('h4')[0].children[0].text,
          platform: App::PLATFORMS[kind.to_sym]
        },
        'num' => live.search('span.popular').text.gsub(/\s/, '')
      }
    end
  rescue StandardError => e
    exception_log(e, "#{App::PLATFORMS[kind.to_sym]}: #{page_url}")
    []
  end

  def chushou_data(page_url)
    kind = 'chushou'
    page = @agent.get(page_url)
    lives = page.search('div#liveContent a')
    lives.map do |live|
      {
        'detail' => {
          url: File.join(App::DOMAINS[kind.to_sym], live.attributes['href'].value),
          img_url: live.search('img.liveImages')[0].attributes['data-imgsrc'].value,
          name: live.search('span.livePlayerName')[0].attributes['title'].value,
          title: live.search('span.videoName')[0].attributes['title'].value,
          platform: App::PLATFORMS[kind.to_sym]
        },
        'num' => live.search('span.liveCount')[0].children[0].text
      }
    end
  rescue StandardError => e
    exception_log(e, "#{App::PLATFORMS[kind.to_sym]}: #{page_url}")
    []
  end

  def update_lives(list, cache_key)
    Redis.current.del cache_key
    list.each do |data|
      Redis.current.zadd(cache_key, convert_float(data['num']), JSON.generate(data['detail']))
    end
  end

  def exception_log(e, game)
    @logger.info("----- #{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')} 抓取#{game}异常 -----")
    @logger.info("Backtrace:\n\t#{e.backtrace.join("\n\t")}")
  end
end
