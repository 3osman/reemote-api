class Consumer
	def get_results(platform, query)
	
		case platform
            when "youtube"
                return HTTParty.get("https://www.googleapis.com/youtube/v3/search?key="+ENV["google_api_key"]+"&maxResults=50"+"&part=id,snippet&q=#{query}&eventType=live&type=video&videoEmbeddable=true&order=viewCount")
            when "twitch"
                return HTTParty.get("https://api.twitch.tv/kraken/search/streams?limit=20&q="+query+"&stream_type=live", headers: {'Client-ID' => ENV["twitch_client_id"]})
            when "periscope"
                return HTTParty.get("https://www.periscope.tv/search?q=#{query}")
        end
	end

	def get_video_info(platform, id)

		case platform
            when "youtube"
                return HTTParty.get("https://www.googleapis.com/youtube/v3/videos?key="+ENV["google_api_key"]+"&id=" + id + "&part=statistics,snippet") 
            when "twitch"
                return HTTParty.get("https://api.twitch.tv/kraken/streams/" + id, headers: {'Client-ID' => ENV["twitch_client_id"]})     
            when "periscope"
                return HTTParty.get("https://api.periscope.tv/api/v2/accessVideoPublic?broadcast_id=#{id}")
        end
	end

end