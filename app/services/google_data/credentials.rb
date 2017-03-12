module GoogleData
  class Credentials < Struct.new(:api_key, :engine_id)
    def initialize(api_key: ENV["API_KEY"], engine_id: ENV["ENGINE_ID"])
      super(api_key, engine_id) 
    end
  end
end