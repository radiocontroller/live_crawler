# frozen_string_literal: true

require './app'
run App

$redis = Redis.new(host: '127.0.0.1', port: '6379')