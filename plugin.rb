# frozen_string_literal: true

# name: discourse-daily-reply-limit
# about: Limit the number of daily replies for users not in selected groups, encouraging users to upgrade for unlimited participation.
# version: 0.0.1
# authors: Jahan Gagan
# url: https://github.com/jahan-ggn/discourse-daily-reply-limit

enabled_site_setting :discourse_daily_reply_limit_enabled

module ::DiscourseDailyReplyLimit
  PLUGIN_NAME = "discourse-daily-reply-limit"
end

require_relative "lib/discourse_daily_reply_limit/engine"

after_initialize do
  module ::CustomPostCreatorExtension
    def valid?
      super && custom_reply_limit_valid?
    end

    private

    def custom_reply_limit_valid?
      return true unless SiteSetting.discourse_daily_reply_limit_enabled

      return true if @user.admin? || @user.staff?

      exempt_group_ids = SiteSetting.discourse_daily_reply_limit_exempt_groups
        .split("|")
        .map(&:to_i)
        .reject(&:zero?)
      
      return true if exempt_group_ids.any? && (@user.group_ids & exempt_group_ids).any?
      
      max_replies = SiteSetting.discourse_daily_reply_limit_max_replies

      replies_today = Post.where(
        user_id: @user.id,
        post_type: Post.types[:regular],
        created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      ).count

      if replies_today >= max_replies
        info_link = ""
        if SiteSetting.discourse_daily_reply_limit_info_topic_url.present?
          link_text = SiteSetting.discourse_daily_reply_limit_info_link_text
          url = SiteSetting.discourse_daily_reply_limit_info_topic_url
          info_link = "<a href='#{url}' target='_blank'>#{link_text}</a>"
        end

        error_message =
          SiteSetting.discourse_daily_reply_limit_error_message.gsub("%{info_link}", info_link)

        errors.add(:base, error_message)
        return false
      end

      true
    end
  end

  ::PostCreator.prepend(::CustomPostCreatorExtension)
end
