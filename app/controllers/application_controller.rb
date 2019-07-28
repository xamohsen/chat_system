class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  def messaging_service
    MESSAGING_SERVICE
  end
end