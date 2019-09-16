class AuthorizationsController < ApplicationController
  # before_action :authenticate
  http_basic_authenticate_with name: 'TestUser', password: 'TestUser'

  def show
    # uri = request.headers['X-Original-URI']
    # logger.debug url
    head :ok
  end

  # private

  # def authenticate
  #   unless authenticate_with_http_basic { |email, pass| User.find_by(email: email)&.authenticate(pass) }
  #     request_http_basic_authentication
  #   end
  # end
end
