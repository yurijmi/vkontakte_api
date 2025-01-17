# frozen_string_literal: true

module VkontakteApi
  # Faraday middleware for logging requests and responses.
  #
  # It's behaviour depends on the logging options in the configuration.
  class Logger < Faraday::Response::Middleware
    # Creates a middleware instance.
    # The logger is set from `:logger` configuration option.
    def initialize(app)
      super(app)
      @logger = VkontakteApi.logger
    end

    # Logs the request if needed.
    # @param [Hash] env Request data.
    def call(env)
      if VkontakteApi.log_requests?
        @logger.debug "#{env[:method].to_s.upcase} #{env[:url]}"
        @logger.debug "body: #{env[:body].inspect}" unless env[:method] == :get
      end

      super
    end

    # Logs the response (successful or not) if needed.
    # @param [Hash] env Response data.
    def on_complete(env)
      if env[:body].error? && VkontakteApi.log_errors?
        @logger.warn env[:raw_body]
      elsif VkontakteApi.log_responses?
        @logger.debug env[:raw_body]
      end
    end
  end

  Faraday::Response.register_middleware vk_logger: Logger
end
