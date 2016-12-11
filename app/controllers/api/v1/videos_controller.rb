# app/controllers/api/v1/videos_controller.rb
require 'json'

module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
    	query =  params['query']
    	platforms = params['platforms'] || "youtube,twitch"
    	num = params['num'] || 1
        all_vids = Array.new
    	#you_vids = get_youtube(query,num)
    	#you_vids = get_periscope(query,num)
        all_vids.push get_twitch(query,num) if platforms.include? "twitch"
        all_vids.push get_youtube(query,num) if platforms.include? "youtube"

    	render json: all_vids
    end
    def get_youtube(query,num)
    	maxResults = "&maxResults=50"
    	response = HTTParty.get("https://www.googleapis.com/youtube/v3/search?key="+ENV["google_api_key"]+"#{maxResults}"+"&part=id,snippet&q=#{query}&eventType=live&type=video&videoEmbeddable=true")     
      	return handle_youtube_videos(response)
    end

    def get_twitch(query,num)
        response = HTTParty.get("https://api.twitch.tv/kraken/search/streams?limit=50&q="+query, headers: {'Client-ID' => ENV["twitch_client_id"]})     
        return handle_twitch_videos(response)
    end

    def get_periscope(query,num)
    	return $twitter_client.search("live from the moon filter:periscope -rt", result_type: "recent", count: 5)
    end

    def handle_youtube_videos(response)
        videos = Array.new
        JSON.parse(response.body)["items"].each do |it|
           item = {"platform": "youtube","title": it["snippet"]["title"], "thumbnail": it["snippet"]["thumbnails"]["default"]["url"],"streaming_url": "//www.youtube.com/embed/" + it["id"]["videoId"], "browser_url": "https://www.youtube.com/watch?v=" + it["id"]["videoId"] }
           videos.push item
        end
        return videos
    end

    def handle_twitch_videos(response)
        videos = Array.new
        JSON.parse(response.body)["streams"].each do |it|
           channel_name = it["channel"]["name"]
           item = {"platform": "twitch","title": it["game"], "thumbnail": it["preview"]["medium"],"streaming_url": "http://player.twitch.tv/?channel=" + channel_name, "browser_url": "https://www.twitch.tv/" + channel_name }
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
           