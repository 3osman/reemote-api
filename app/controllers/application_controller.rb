class ApplicationController < ActionController::API
	rescue_from Rack::Timeout::RequestTimeoutError, :with => :handle_timeout
	protected

	def handle_timeout(exception)
		render json: {"error": "Youtube or twitch external API call timeout, try again later"}
	end
end
