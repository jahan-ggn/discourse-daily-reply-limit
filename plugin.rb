# frozen_string_literal: true

# name: discourse-daily-reply-limit
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_daily_reply_limit_enabled

module ::DiscourseDailyReplyLimit
  PLUGIN_NAME = "discourse-daily-reply-limit"
end

require_relative "lib/discourse_daily_reply_limit/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
