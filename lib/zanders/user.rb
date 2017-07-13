module Zanders
  class User < SoapClient

    attr_reader :username, :password

    def initialize(options = {})
      requires!(options, :username, :password)

      @username = options[:username]
      @password = options[:password]
    end

    def authenticated?
      response = soap_client(ITEM_API_URL).call(:login_check, message: build_request_data)
      response = response.body[:login_check_response][:return][:item]

      response.first[:value] == "0"
    end

    private

    def build_request_data
      {
        username: @username,
        password: @password
      }
    end

  end
end
