# frozen_string_literal: true

require "vkontakte_api"
require "pry"
require "awesome_print"
require_relative "./support/mechanized_authorization"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.before(:suite) do
    Hashie.logger = Logger.new(nil)
  end
end

RSpec::Matchers.define :log_requests do
  match(&:log_requests?)
end

RSpec::Matchers.define :log_errors do
  match(&:log_errors?)
end

RSpec::Matchers.define :log_responses do
  match(&:log_responses?)
end
