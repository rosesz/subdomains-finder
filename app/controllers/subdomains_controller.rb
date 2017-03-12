class SubdomainsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        subdomains = GoogleData::Fetcher.call(params[:domain])
        render json: subdomains
      end
    end
    
  rescue GoogleData::FetchingError => e
    render json: { error: e.message }, status: 422
  end
end
