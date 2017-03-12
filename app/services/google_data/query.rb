module GoogleData
  class Query
    attr_accessor :domain, :subdomains

    def initialize(domain)
      @domain     = domain
      @subdomains = []
    end

    def query_text
      "site:*.#{domain} -inurl:www #{subdomains_to_eliminate}"
    end

    def size_exceeded?
      query_text.gsub(/[[:punct:]]/, '').gsub(' ', '').size > 128 || subdomains.size > 48
    end

    def add_subdomains(new_subdomains)
      @subdomains |= new_subdomains
    end

    private

    def subdomains_to_eliminate
      subdomains.map { |subdomain| to_eliminable(subdomain) }.join(" ")
    end

    def to_eliminable(subdomain)
      subdomain.chomp!(".#{domain}")
      "-inurl:#{subdomain}"
    end
  end
end