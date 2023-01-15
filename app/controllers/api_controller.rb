class ApiController < ActionController::API

  def not_found_method
    render json: {success: false, message: 'This route is not supported'}, status: :not_found
  end
end

