# app/controllers/api/v1/videos_controller.rb
require 'json'
require 'uri'
module Api::V1
  class VideosController < ApiController
    require 'data_processor.rb'
    include DataProcessor

    # GET /v1/search
    def search
        if params['query']
            query =  params['query']
            platforms = params['platforms'] || "youtube,twitch,periscope"
            all_vids = Hash.new
            consumer = Consumer.new
            all_vids["youtube"] = get_youtube(consumer, query) if platforms.include? "youtube"
            all_vids["twitch"] = get_twitch(consumer, query) if platforms.include? "twitch"
            all_vids["periscope"] = get_periscope(consumer, query) if platforms.include? "periscope"

        end
    	render json: all_vids
    end
    def get_youtube(consumer, query)
        return DataProcessor.process_search_results("youtube", consumer.get_results("youtube", query))
    end

    def get_twitch(consumer, query)
        return DataProcessor.process_search_results("twitch", consumer.get_results("twitch", query))
    end
    def get_periscope(consumer, query)
        return DataProcessor.process_search_results("periscope", consumer.get_results("periscope", query))
    end

    
    # GET /v1/info
    def info
        if params["id"]
            consumer = Consumer.new
            id = params["id"]
            case params["platform"]
                when "youtube"
                    item = DataProcessor.process_info("youtube", consumer.get_video_info("youtube", id), id)
                when "twitch"
                    item = DataProcessor.process_info("twitch", consumer.get_video_info("twitch", id), id)
                when "periscope"
                    item = DataProcessor.process_info("periscope", consumer.get_video_info("periscope", id), id)
            end
        end
        render json: item
    end
  end
end