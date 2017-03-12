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
      parsed[:error][:errors].first.try(:[], :reason).try(:titleize)
    end

    private

    def parsed
      JSON.parse(response.body).try(:with_indifferent_access)
    end

    def base_link?(link)
      link.match(/^.*\.[a-zA-Z]*.\/?$/).present?
    end
  end
end