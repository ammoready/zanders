module Zanders
  class Item < SoapClient

    attr_reader :username
    attr_reader :password

    # Public: Initialize a new Item interface with
    # username and password
    #
    # options - Hash of username and password
    #
    # Returns a new Item service interface
    def initialize(options = {})
      requires!(options, :username, :password)

      @username = options[:username]
      @password = options[:password]
      @testing  = options.fetch(:testing, false)
    end

    # Public: Get item info by item number
    #
    # item_number - Integer of the item number
    #
    # Returns Hash containing item info, or an error code if
    # the call failed
    def get_info(item_number)
      request_data = build_request_data({ itemnumber: item_number })

      response = soap_client(ITEM_API_URL).call(:get_item_info, message: request_data)
      response = response.body[:get_item_info_response][:return][:item]

      # Successful call return_code is 0
      if response.first[:value] == "0"
        info = Hash.new

        # Let's toss the data we need into a ruby-ish hash
        response.each do |info_part|
          case info_part[:key]
          when  "itemNumber"
            info[:item_number] = info_part[:value]
          when "itemDescription"
            info[:description] = info_part[:value]
          when "itemPrice"
            info[:price] = info_part[:value]
          when "itemWeight"
            info[:weight] = info_part[:value]
          when "numberAvailable"
            info[:quantity] = info_part[:value]
          else
            next
          end
        end

        info[:success] = true

        info
      else
        { success: false, error_code: response.first[:value] }
      end
    end

    # Public: Get item quantity by item number
    #
    # item_number - Integer of the item number
    #
    # Returns Hash containing item quantity, or an error code
    # if the call failed
    def get_quantity(item_number)
      request_data = build_request_data({ itemnumber: item_number })

      response = soap_client(ITEM_API_URL).call(:get_item_inventory, message: request_data)
      response = response.body[:get_item_inventory_response][:return][:item]

      # Successful call return_code is 0
      if response.first[:value] == "0"
        quantity = Hash.new

        # We only need the quantity out of the data received
        quantity[:quantity] = response.find { |i| i[:key] == "numberAvailable" }[:value].to_i
        quantity[:success]  = true

        quantity
      else
        { success: false, error_code: response.first[:value] }
      end
    end

    private

    # Private: Combines request data with the username and password
    #
    # hash - Hash of request data
    #
    # Returns merged Hash
    def build_request_data(hash)
      {
        username: @username,
        password: @password,
        testing:  @testing
      }.merge(hash)
    end

  end
end
