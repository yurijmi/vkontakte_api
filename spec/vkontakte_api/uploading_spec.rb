# frozen_string_literal: true

require "spec_helper"

describe VkontakteApi::Uploading do
  let(:uploader) do
    Object.new.tap do |object|
      object.extend VkontakteApi::Uploading
    end
  end

  describe "#upload" do
    let(:upload_io)     { double("Faraday::UploadIO instance") }
    let(:response_body) { double("Server response body") }
    let(:response)      { double("Server response", body: response_body) }
    let(:connection)    { double("Faraday connection", post: response) }

    before(:each) do
      allow(Faraday::UploadIO).to receive(:new).and_return(upload_io)
      allow(VkontakteApi::API).to receive(:connection).and_return(connection)
    end

    context "without a :url param" do
      it "raises an ArgumentError" do
        expect {
          uploader.upload
        }.to raise_error(ArgumentError)
      end
    end

    it "creates a Faraday::UploadIO for each file passed in" do
      path = double("File path")
      type = double("File mime type")
      io = double("File IO")

      expect(Faraday::UploadIO).to receive(:new).with(path, type, nil)
      expect(Faraday::UploadIO).to receive(:new).with(io, type, path)
      uploader.upload(url: "http://example.com", file1: [path, type], file2: [io, type, path])
    end

    it "POSTs the files through the connection to a given URL" do
      url  = double("URL")
      file = double("File")
      expect(connection).to receive(:post).with(url, file1: upload_io)
      uploader.upload(url: url, file1: file)
    end

    it "returns the server response" do
      expect(uploader.upload(url: "http://example.com")).to eq(response_body)
    end

    context "with a :files param" do
      it "uploads the files as file1, file2 etc" do
        url = double("URL")
        type = double("File mime type")
        file1 = double("First file")
        file2 = double("Second file")

        expect(Faraday::UploadIO).to receive(:new).with(file1, type, nil)
        expect(Faraday::UploadIO).to receive(:new).with(file2, type, nil)
        expect(connection).to receive(:post).with(url, file1: upload_io, file2: upload_io)

        uploader.upload(
          url:   url,
          files: [
            [file1, type],
            [file2, type]
          ]
        )
      end
    end
  end
end
