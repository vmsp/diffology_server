require 'test_helper'

class AuthorizationsControllerTest < ActionDispatch::IntegrationTest
  test 'require access' do
    get authorization_url
    assert_response :unauthorized
  end

  test 'access granted' do
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(users(:user1).email, 'user1')
    get authorization_url, headers: { 'HTTP_AUTHORIZATION' => auth }
    assert_response :ok
  end
end
