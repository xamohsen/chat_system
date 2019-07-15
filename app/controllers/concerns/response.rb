module Response
  def json_response(object, status = :ok)
    if object == nil
      render json: {message: 'not fond'}, status: :not_found
    else
      render json: object.as_json(:except => :id), status: status
    end
  end
end

module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({message: e.message}, :not_found)
    end
    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({message: e.message}, :unprocessable_entity)
    end
  end
end