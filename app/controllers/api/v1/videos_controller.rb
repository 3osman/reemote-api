# app/controllers/api/v1/videos_controller.rb
require 'json'

module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
        if params['query']
            query =  params['query']
            platforms = params['platforms'] || "youtube,twitch"
            all_vids = Hash.new
            #all_vids.push get_periscope(query,num) if platforms.include? "periscope"
            all_vids["youtube"] = get_youtube(query) if platforms.include? "youtube"
            all_vids["twitch"] = get_twitch(query) if platforms.include? "twitch"
        end
    	render json: all_vids
    end
    def get_youtube(query)
    	maxResults = "&maxResults=50"
    	response = HTTParty.get("https://www.googleapis.com/youtube/v3/search?key="+ENV["google_api_key"]+"#{maxResults}"+"&part=id,snippet&q=#{query}&eventType=live&type=video&videoEmbeddable=true&order=viewCount")     
      	return handle_youtube_videos(response)
    end

    def get_twitch(query)
        response = HTTParty.get("https://api.twitch.tv/kraken/search/streams?limit=20&q="+query+"&stream_type=live", headers: {'Client-ID' => ENV["twitch_client_id"]})     
        return handle_twitch_videos(response)
    end

    def get_periscope(query,num)
    	return $twitter_client.search("live from the moon filter:periscope -rt", result_type: "recent", count: 5)
    end

    def handle_youtube_videos(response)
        videos = Array.new
        JSON.parse(response.body)["items"].each do |it|
           item = {"title": it["snippet"]["title"], "thumbnail": it["snippet"]["thumbnails"]["default"]["url"],"streaming_url": "//www.youtube.com/embed/" + it["id"]["videoId"], "browser_url": "https://www.youtube.com/watch?v=" + it["id"]["videoId"] }
           videos.push item
        end
        return videos
    end

    def handle_twitch_videos(response)
        videos = Array.new
        JSON.parse(response.body)["streams"].each do |it|
           channel_name = it["channel"]["name"]
           item = {"title": it["game"] + " : " + it["channel"]["status"], "thumbnail": it["preview"]["medium"],"streaming_url": "http://player.twitch.tv/?channel=" + channel_name, "browser_url": "https://www.twitch.tv/" + channel_name }
           videos.push item
        end
        return videos
    end
    # GET /v1/info
    def info
        if params["id"]
            id = params["id"]
            case params["platform"]
                when "youtube"
                    response = HTTParty.get("https://www.googleapis.com/youtube/v3/videos?key="+ENV["google_api_key"]+"&id=" + id + "&part=statistics,snippet")
                    if JSON.parse(response.body)["pageInfo"]["totalResults"] > 0
                        video = JSON.parse(response.body)["items"].first
                        item = { "title": video["snippet"]["title"], "thumbnail": video["snippet"]["thumbnails"]["default"]["url"], "streaming_url": "//www.youtube.com/embed/" + id, "browser_url": "https://www.youtube.com/watch?v=" + id, "viewers": video['statistics']['viewCount'] }
                    end
                when "twitch"
                    response = HTTParty.get("https://api.twitch.tv/kraken/streams/" + id, headers: {'Client-ID' => ENV["twitch_client_id"]})     
                    video = JSON.parse(response.body)
                    item = {"title": video["stream"]["game"] + " : " + video["stream"]["channel"]["status"], "thumbnail": video["stream"]["preview"]["medium"],"streaming_url": "http://player.twitch.tv/?channel=" + id, "browser_url": "https://www.twitch.tv/" + id, "viewers": video['stream']['viewers']} if video["stream"]
            end
        end
        render json: item
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
           