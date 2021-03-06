module GoogleData
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def items_present?
      parsed[:items].present?
    end

    def links
      return [] unless items_present?

      parsed[:items].map { |item| item["displayLink"] }.select { |link| base_link?(link) }
    end

    def success?
      response.status == 200
    end

    def error
      parsed.dig(:error, :errors)&.first&.[](:reason)&.titleize
    end

    private

    def parsed
      JSON.parse(response.body)&.with_indifferent_access
    end

    def base_link?(link)
      (link =~ /^.*\.[a-zA-Z]*.\/?$/).present?
    end
  end
end