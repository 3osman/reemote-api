module DataProcessor
    require 'json'

	def process_search_results(platform, results)
		case platform
            when "youtube"
                return handle_youtube_videos(results)
            when "twitch"
            	return handle_twitch_videos(results)    
            when "periscope"
            	return handle_periscope_videos(results)   
            end
		
	end

	def process_info(platform, video, id)
		case platform
            when "youtube"
                puts JSON.pretty_generate(video)
                if JSON.parse(video.body)["pageInfo"]["totalResults"] > 0
                    video = JSON.parse(video.body)["items"].first
                    item = { "title": video["snippet"]["title"], "thumbnail": video["snippet"]["thumbnails"]["default"]["url"], "streaming_url": "//www.youtube.com/embed/" + id +"?autoplay=1", "browser_url": "https://www.youtube.com/watch?v=" + id, "viewers": video['statistics']['viewCount'] }
                end
            when "twitch"
                video = JSON.parse(video.body)
                item = {"title": video["stream"]["game"] + " : " + video["stream"]["channel"]["status"], "thumbnail": video["stream"]["preview"]["medium"],"streaming_url": "http://player.twitch.tv/?channel=" + id, "browser_url": "https://www.twitch.tv/" + id, "viewers": video['stream']['viewers']} if video["stream"]
            when "periscope"
                video = JSON.parse(video.body)
                item = {"title": video["broadcast"]["status"], "thumbnail": video["broadcast"]["image_url"],"streaming_url": "https://www.periscope.tv/w/"+id, "browser_url": "https://www.periscope.tv/w/"+id, "hls_url": video["hls_url"]}
        end
        return item
	end

	def self.handle_youtube_videos(response)
        videos = Array.new
        JSON.parse(response.body)["items"].each do |it|
           item = {"id": it["id"]["videoId"],"title": it["snippet"]["title"], "thumbnail": it["snippet"]["thumbnails"]["default"]["url"]}
           videos.push item
        end
        return videos
    end

    def self.handle_twitch_videos(response)
        videos = Array.new
        JSON.parse(response.body)["streams"].each do |it|
           channel_name = it["channel"]["name"]
           item = {"id": channel_name,"title": it["game"] + " : " + it["channel"]["status"], "thumbnail": it["preview"]["medium"]}
           videos.push item
        end
        return videos
    end
    def self.handle_periscope_videos(response)
    	response = response.split("data-store=")[1].split(">")[0].gsub! '&quot;','"'
        response[0] = ''
        response[response.length-1]=''
        videos = Array.new
        JSON.parse(response)["BroadcastCache"]["broadcasts"].each do |k,v|
            
            if v["broadcast"]["data"]["state"].eql?"RUNNING"
                image_url = CGI::unescapeHTML(v["broadcast"]["image_url"])
                title = CGI::unescapeHTML(v["broadcast"]["data"]["status"])
                item = item = {"id": k,"title": title, "thumbnail": image_url}
                videos.push item
            end
        end
        return videos
        
    end
    module_function :process_info
    module_function :process_search_results

end