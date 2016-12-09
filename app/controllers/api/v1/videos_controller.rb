# app/controllers/api/v1/users_controller.rb
module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
    	query =  params['query']
    	platforms = params['platforms'] || "youtube,periscope"
    	num = params['num'] || 1
    	puts query
    	puts platforms
    	puts num
    	response = HTTParty.get('https://www.googleapis.com/youtube/v3/search?key='+ENV["google_api_key"]+'&maxResults=5&part=id,snippet&q=test&eventType=live&type=video')
    	#puts $twitter_client.search("Renan preside o Senado neste momento: o triunfo do cinismo e a derrota do Estado de Direito filter:periscope").to_json
    	#puts response.body, response.code, response.message, response.headers.inspect
    	render json: {"search_query":query}
    end

  end
end