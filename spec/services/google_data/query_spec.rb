require 'rails_helper'

RSpec.describe GoogleData::Query do
  subject { described_class.new(domain) }

  let(:domain)     { "example.com" }
  let(:subdomains) { ["firstsub.example.com", "secondsub.example.com"] }
    
  describe "#query_text" do
    it "builds correct query" do
      subject.add_subdomains(subdomains)
      expexted_text = "site:*.example.com -inurl:www -inurl:firstsub -inurl:secondsub"

      expect(subject.query_text).to eq(expexted_text)
    end
  end
end
