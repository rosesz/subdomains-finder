require 'rails_helper'

RSpec.describe GoogleData::Fetcher do
  subject { described_class.new(domain, credentials) }
  
  let(:credentials) { GoogleData::Credentials.new(api_key: "samplekey", engine_id: "sampleid") }

  context "with correct domain" do
    let(:domain) { "onet.pl" }

    it "returns subdomains" do
      VCR.use_cassette("search_results") do
        links = subject.call
        expect(links).not_to be_empty
      end
    end

    context "invalid credentials" do
     let(:credentials) { GoogleData::Credentials.new(api_key: "", engine_id: "sampleid") }
     
      it "raises error" do
        VCR.use_cassette("invalid_credentials") do
          expect { subject.call }.to raise_error(GoogleData::FetchingError, "Key Invalid")
        end
      end
    end
  end

  context "with empty domain" do
    let(:domain) { "" }
    
    it "raises error" do
      expect { subject.call }.to raise_error(GoogleData::FetchingError, "No domain given")
    end
  end
end
