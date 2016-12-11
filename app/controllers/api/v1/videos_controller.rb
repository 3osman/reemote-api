# app/controllers/api/v1/videos_controller.rb
require 'json'

module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
    	query =  params['query']
    	platforms = params['platforms'] || "youtube,periscope"
    	num = params['num'] || 1
    	you_vids = get_youtube(query,num)
    	#you_vids = get_periscope(query,num)
    	render json: you_vids
    end
    def get_youtube(query,num)
    	maxResults = "&maxResults=50"
    	response = HTTParty.get("https://www.googleapis.com/youtube/v3/search?key="+ENV["google_api_key"]+"#{maxResults}"+"&part=id,snippet&q=#{query}&eventType=live&type=video&videoEmbeddable=true")     
      	return handle_youtube_videos(response)
    end

    def get_periscope(query,num)
    	return $twitter_client.search("#Periscope'ta CANLI filter:periscope -rt", result_type: "recent", count: 2).to_json
    end

    def handle_youtube_videos(response)
        videos = Array.new
        JSON.parse(response.body)["items"].each do |it|
           item = {"platform": "youtube","title": it["snippet"]["title"], "streaming_url": "//www.youtube.com/embed/" + it["id"]["videoId"], "browser_url": "https://www.youtube.com/watch?v=" + it["id"]["videoId"] }
           videos.push item
        end
        return videos
    end

  end
end





#ids = response['items'].map{ |it| it['id']['videoId']}.join(',')
    	#video_players = HTTParty.get("https://www.googleapis.com/youtube/v3/videos?key="+ENV["google_api_key"]+"&part=player&id=#{ids}")
    	#vids = Array.new


         # video_titles = response['items'].map{ |it| it['snippet']['title'] }.join(',')
        #video_players = response['items'].map{ |it| "//www.youtube.com/embed/#{it['id']['videoId']}"}.join(',')
        #video_urls = response['items'].map {|it| "https://www.youtube.com/watch?v=#{it["id"]["videoId"]}"}.join(',')
    

     # item["platform"] = "youtube"
            #item["title"] = it["snippet"]["title"]
            #item["streaming_url"] = "//www.youtube.com/embed/" + it["id"]["videoId"]
            #item["browser_url"] = "https://www.youtube.com/watch?v=" + it["id"]["videoId"]
           