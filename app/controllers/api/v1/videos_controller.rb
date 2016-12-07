# app/controllers/api/v1/users_controller.rb
module Api::V1
  class VideosController < ApiController

    # GET /v1/search
    def search
    	query =  params['query']
    	puts "in index"
    	render json: {"test":query}
    end

  end
end