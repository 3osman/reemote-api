# app/controllers/api/v1/users_controller.rb
module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
    	query =  params['query']
    	platforms = params['platforms'] || "youtube,periscope"
    	num = params['num'] || 1
    	you_vids = get_youtube(query,num)
    	get_periscope(query,num)
    	#puts response.body, response.code, response.message, response.headers.inspect
    	render json: {"response":you_vids}
    end

    def get_youtube(query,num)
    	#maxResults = "&maxResults=5"
    	maxResults = ""
    	response = HTTParty.get("https://www.googleapis.com/youtube/v3/search?key="+ENV["google_api_key"]+"#{maxResults}"+"&part=id&q=#{query}&eventType=live&type=video&videoEmbeddable=true")
    	#ids = response['items'].map{ |it| it['id']['videoId']}.join(',')
    	#video_players = HTTParty.get("https://www.googleapis.com/youtube/v3/videos?key="+ENV["google_api_key"]+"&part=player&id=#{ids}")
    	#vids = Array.new
    	video_players = response['items'].map{ |it| "//www.youtube.com/embed/#{it['id']['videoId']}"}.join(',')
    	return video_players
    end
    def get_periscope(query,num)
    	$twitter_client.search("#{query} filter:periscope").to_json
    end

  end
end