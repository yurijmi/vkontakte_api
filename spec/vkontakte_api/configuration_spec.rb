# frozen_string_literal: true

require "spec_helper"

class Configurable
  extend VkontakteApi::Configuration
end

describe VkontakteApi::Configuration do
  describe "#configure" do
    it "yields self" do
      expect(Configurable).to receive(:some_method)
      Configurable.configure(&:some_method)
    end

    it "returns self" do
      expect(Configurable.configure).to eq(Configurable)
    end
  end

  describe "#reset" do
    it "sets all options to their default values" do
      Configurable.reset

      expect(Configurable.app_id).to be_nil
      expect(Configurable.app_secret).to be_nil
      expect(Configurable.adapter).to eq(VkontakteApi::Configuration::DEFAULT_ADAPTER)
      expect(Configurable.http_verb).to eq(VkontakteApi::Configuration::DEFAULT_HTTP_VERB)
      expect(Configurable.faraday_options).to eq({})

      expect(Configurable.logger).to be_a(Logger)
      expect(Configurable).to log_requests
      expect(Configurable).to log_errors
      expect(Configurable).not_to log_responses
      expect(Configurable.api_version).to eq(VkontakteApi::Configuration::DEFAULT_API_VERSION)
    end
  end
end
