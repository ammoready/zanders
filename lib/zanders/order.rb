module Zanders
  class Order < SoapClient

    ##
    # == Order Service
    #
    # Return Codes
    # 0: Success
    # 1: Username and/or Password were incorrect
    # 2: There was a problem creating the order
    # 5: Cannot create order with no items
    # 9: Order not created because all items not available and not to be back ordered
    # 10: Ship date cannot be before today
    # 11: Ship date cannoy be more than 30days in the future
    # 21: The order number is NOT connected to your customer number
    # 31: Can NOT add item with quantity of less than 1
    # 41: The item number requested is NOT connected to this order

    attr_reader :username, :password, :options

    # Public: Initialize a new Order
    #
    # options - Hash of username, password, and address information
    #
    # Returns an Order service interface
    def initialize(options = {})
      requires!(options, :username, :password)

      @username = options[:username]
      @password = options[:password]

      @options = options
    end

    # Public: Create a new order
    #
    # items - Array of hashes containing item_number and quantity
    #
    # Returns an order_number
    def create_order(items, address)
      order = build_order_data
      order_items = Array.new

      items.each do |item|
        order_items.push(item: [
          { key: 'itemNumber', value: item[:item_number] },
          { key: 'quantity', value: item[:quantity] },
          { key: 'allowBackOrder', value: false }
        ])
      end

      ship_to_number = Zanders::Address.ship_to_number(address, @options)

      if ship_to_number[:success]
        shipping_information = [
          { key: 'shipToNo', value: ship_to_number[:ship_to_number] },
          { key: 'shipDate', value: Time.now.strftime("%Y-%m-%d") },
          # TODO-david
          { key: 'ShipViaCode', value: 'UG' },
          # TODO-david
          { key: 'purchaseOrderNumber', value: '4567' }
        ]

        # NOTE-david
        # order(ns2 map)
        #   item
        #     key
        #     value(ns2map)
        #       item  - order item
        #       item  - order item
        #   item
        #     "
        #   
        order[:order] = Hash.new
        order[:order][:item] = shipping_information

        order_items = {item: order_items, attributes!: { item: { "xsi:type" => "ns2:Map"} }}

        order[:order][:item].push({
          key: 'items',
          value: order_items
        })

        response = soap_client(ORDER_API_URL).call(:create_order, message: order)
        response = response.body[:create_order_response][:return][:item]

        if response.first[:value] == "0"
          { success: true, order_number: response.last[:value] }
        else
          { success: false, error_code: response.first[:value] }
        end
      end
    end

    # Public: Get order info
    #
    # order_number - The String order number
    #
    # Returns Hash containing order information, or an error
    # code if the call failed
    def get_order(order_number)
      order = build_order_data.merge({ ordernumber: order_number })

      response = soap_client(ORDER_API_URL).call(:get_order_info, message: order)
      response = response.body[:get_order_info_response][:return][:item]

      # Successful call return_code is 0
      if response.first[:value] == "0"
        info = Hash.new

        # Just use the order number we already have
        info[:order_number] = order_number

        # Transform the response into a ruby-ish hash
        response.each do |part|
          case part[:key]
          when "purchaseOrderNumber"
            info[:purchase_order_number] = part[:value]
          when "orderDate"
            info[:order_date] = part[:value]
          when "orderEnteredDate"
            info[:ordered_entered_date] = part[:value]
          when "orderShipDate"
            info[:order_ship_date] = part[:value]
          when "subtotal"
            info[:subtotal] = part[:value]
          when "freight"
            info[:freight] = part[:value]
          when "miscFee"
            info[:misc_fee] = part[:value]
          when "selectionCode"
            info[:selection_code] = part[:value]
          when "datePicked"
            info[:date_picked] = part[:value]
          when "grandTotal"
            info[:grand_total] = part[:value]
          end
        end

        info[:success] = true

        info
      else
        { success: false, error_code: response.first[:value] }
      end
    end

    private

    # Private: Builds request data
    #
    # Returns Hash of username, password, and cast assignments
    def build_order_data
      hash = {
        :attributes! => {
          order: { "xsi:type" => "ns2:Map" }
        },
        username: @username,
        password: @password,
        testing: true
      }

      hash
    end

  end
end
