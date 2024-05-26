# app/services/unsplash_service.rb
require 'httparty'

class UnsplashService
  include HTTParty
  base_uri 'https://api.unsplash.com'

  def initialize(access_key)
    @access_key = access_key
  end

  def search_photos(query)
    response = self.class.get("/search/photos", query: { query: query }, headers: { "Authorization" => "Client-ID #{@access_key}" })

    if response.success?
      return JSON.parse(response.body)["results"]
    else
      # Handle error response
      return nil
    end
  end
end
