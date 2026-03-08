# frozen_string_literal: true

DiscourseDailyReplyLimit::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw do
  mount ::DiscourseDailyReplyLimit::Engine, at: "discourse-daily-reply-limit"
end
