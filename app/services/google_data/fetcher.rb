require "faraday"

module GoogleData
  class Fetcher
    attr_accessor :domain, :subdomains, :api_key, :engine_id, :max_elimination_tries, :results_limit

    def initialize(domain, api_key: nil, engine_id: nil)
      @domain     = domain
      @subdomains = []
      @api_key    = api_key   || ENV["API_KEY"] 
      @engine_id  = engine_id || ENV["ENGINE_ID"]
      @max_elimination_tries = ENV["MAX_ELIMINATION_TRIES"] || 10
      @results_limit         = ENV["RESULTS_LIMIT"] || 30
    end

    def self.call(domain)
      new(domain).call
    end

    def call
      raise FetchingError.new("No domain given") if domain.blank?

      fetch_with_elimination
      fetch_with_limit if query.size_exceeded?

      subdomains.uniq
    end

    private

    def connection
      @conn ||= Faraday.new(
        url: "https://www.googleapis.com/customsearch/v1", 
        params: { 
          key: api_key, 
          cx: engine_id,
          num: 10 
        } 
      ) 
    end

    def get_subdomains!(number = nil)
      response = Response.new(connection.get { |req|
        req.params[:q]     = query.query_text
        req.params[:start] = number if number 
      })
      raise FetchingError.new(response.error) unless response.success?
      @subdomains |= response.links
      response
    end

    # remove found subdomains from results until nothing is returned
    def fetch_with_elimination
      max_elimination_tries.times do
        response = get_subdomains!
        break unless response.items_present?
        break if     query.size_exceeded?
        query.add_subdomains(response.links)
      end
    end

    # continue searching in results until given limit
    # if too many subdomains where found to put them in the query
    def fetch_with_limit
      start_result = 10
      start_result.step(results_limit, 10) do |number|
        response = get_subdomains!(number)
        break unless response.items_present?
      end
    end

    def query
      @query ||= Query.new(domain)
    end
  end
end