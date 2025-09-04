# frozen_string_literal: true

module ::DiscourseDailyReplyLimit
  class ExamplesController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    def index
      render json: { hello: "world" }
    end
  end
end
