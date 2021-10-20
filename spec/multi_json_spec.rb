# frozen_string_literal: true

require "spec_helper"

describe MultiJson do
  unless defined?(JRUBY_VERSION)
    it "uses Oj" do
      expect(MultiJson.adapter.to_s).to eq("MultiJson::Adapters::Oj")
    end
  end
end
