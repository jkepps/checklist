class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	rescue_from ActionController::ParameterMissing, with: :malformed_request

	respond_to :json

	def authenticate_user
		authenticate_or_request_with_http_token do |token, options| 
			@current_user = User.find_by(auth_token: token)
		end
	end

	def authorize_user
		unless @current_user
			permission_denied_error
		end
	end

	def permission_denied_error
		error(403, 'Permission Denied!')
	end

	def malformed_request
		error(400, 'The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request qithout modifications')
	end

	def not_found
		error(404, 'Record not found')
	end

	def error(status, message = 'Something went wrong')
		response = {
			response_type: "ERROR",
			message: message
		}

		render json: response.to_json, status: status
	end

end
