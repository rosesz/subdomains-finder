require 'rails_helper'

RSpec.describe SubdomainsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    context "with empty domain" do
      it "returns http unprocessable entity" do
        get :index, format: :json, params: { domain: "" }
        expect(response).to have_http_status(422)
      end
    end
  end
end
