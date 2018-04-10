module Zanders
  class Address < SoapClient

    attr_reader :username
    attr_reader :password

    # Public: Initializes a new Address with username
    # and password
    #
    # username - A String username
    # password - A String password
    #
    # Returns a new Address service interface
    def initialize(options = {})
      requires!(options, :username, :password)

      @username = options[:username]
      @password = options[:password]
      @testing  = options.fetch(:testing, false)
    end

    def self.ship_to_number(address, options = {})
      new(options).ship_to_number(address)
    end

    # Public: Get a shipToNumber for the address
    # provided in `address`
    #
    # address - Hash of the address
    #
    # Returns Hash containing the ship to number, or an error
    # code if the call failed
    def ship_to_number(address)
      request_data = build_request_data(address)

      response = soap_client(ADDRESS_API_URL).call(:use_ship_to, message: request_data)
      response = response.body[:use_ship_to_response][:return][:item]

      # Successful call return_code is 0
      if response.first[:value] == "0"
        ship_to_number = Hash.new

        # Let's dig to get to data we actually need. Yay, digging...
        parts = ship_to_number[:ship_to_number] = response.last[:value].first[1]

        # We only need the ship_to_number out of the data received
        ship_to_number[:ship_to_number] = parts.find { |i| i[:key] == "ShipToNo" }[:value]
        ship_to_number[:success] = true

        ship_to_number
      else
        { success: false, error_code: response.first[:value], error_message: (response.length == 3 ? response[1][:value] : nil) }
      end
    end

    private

    # Private: Combines request data with the username,
    # password, and type-cast assignments
    #
    # hash - Hash of request data
    #
    # Returns merged Hash
    def build_request_data(hash)
      {
        :attributes! => {
          addressinfo: { "xsi:type" => "ns2:Map" },
        },
        username: @username,
        password: @password,
        addressinfo: {
          item: [
            { key: 'name',      value: hash[:name]      },
            { key: 'address1',  value: hash[:address1]  },
            { key: 'address2',  value: hash[:address2]  },
            { key: 'city',      value: hash[:city]      },
            { key: 'state',     value: hash[:state]     },
            { key: 'zip',       value: hash[:zip]       },
            { key: 'fflno',     value: hash[:fflno]     },
            { key: 'fflexp',    value: hash[:fflexp]    }
          ]
        },
        testing: @testing
      }
    end

  end
end
