class ApplicationController < ActionController::API
	rescue_from Rack::Timeout::RequestTimeoutError, with: :handle_timeout
	rescue_from Exception, with: :handle_exception
	protected

	def handle_timeout(exception)
		render json: {"error": "External API call timeout, try again later"}
	end
	def handle_exception(exception)
		render json: {"error": "Something went wrong, contact admin with this message #{exception.message} #{exception.backtrace}"}

	end
end
