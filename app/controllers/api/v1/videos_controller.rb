# app/controllers/api/v1/videos_controller.rb
require 'json'
require 'uri'
module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
        if params['query']
            query =  params['query']
            platforms = params['platforms'] || "youtube,twitch"
            all_vids = Hash.new
            all_vids["youtube"] = get_youtube(query) if platforms.include? "youtube"
            all_vids["twitch"] = get_twitch(query) if platforms.include? "twitch"
            all_vids["periscope"] = get_periscope(query) if platforms.include? "periscope"

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
    def get_periscope(query)
        response = HTTParty.get("https://www.periscope.tv/search?q=#{query}")
        return handle_periscope_videos(response.split("data-store=")[1].split(">")[0].gsub! '&quot;','"')
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
    def handle_periscope_videos(response)
        response[0] = ''
        response[response.length-1]=''
        videos = Array.new
        puts JSON.parse(response)
        JSON.parse(response)["BroadcastCache"]["broadcasts"].each do |k,v|
            
            if v["broadcast"]["data"]["state"].eql?"RUNNING"
                image_url = CGI::unescapeHTML(v["broadcast"]["image_url"])
                title = CGI::unescapeHTML(v["broadcast"]["data"]["status"])
                item = {"title": title, "thumbnail": image_url,"streaming_url": "https://www.periscope.tv/w/"+k, "browser_url": "https://www.periscope.tv/w/"+k }
                videos.push item
            end
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
                        item = { "title": video["snippet"]["title"], "thumbnail": video["snippet"]["thumbnails"]["default"]["url"], "streaming_url": "//www.youtube.com/embed/" + id +"?autoplay=1", "browser_url": "https://www.youtube.com/watch?v=" + id, "viewers": video['statistics']['viewCount'] }
                    end
                when "twitch"
                    response = HTTParty.get("https://api.twitch.tv/kraken/streams/" + id, headers: {'Client-ID' => ENV["twitch_client_id"]})     
                    video = JSON.parse(response.body)
                    item = {"title": video["stream"]["game"] + " : " + video["stream"]["channel"]["status"], "thumbnail": video["stream"]["preview"]["medium"],"streaming_url": "http://player.twitch.tv/?channel=" + id, "browser_url": "https://www.twitch.tv/" + id, "viewers": video['stream']['viewers']} if video["stream"]
                when "periscope"
                    response = HTTParty.get("https://api.periscope.tv/api/v2/accessVideoPublic?broadcast_id=#{id}")
                    video = JSON.parse(response.body)
                    item = {"title": video["broadcast"]["status"], "thumbnail": video["broadcast"]["image_url"],"streaming_url": "https://www.periscope.tv/w/"+id, "browser_url": "https://www.periscope.tv/w/"+id, "hls_url": video["hls_url"]}
            end
        end
        render json: item
    end
  end
end