module Zanders
  class User < SoapClient

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    # TODO-david
    #
    # Waiting on an endpoint for this
    def authenticated?
      true
    end

  end
end
