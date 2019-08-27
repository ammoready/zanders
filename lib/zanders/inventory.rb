module Zanders
  class Inventory < Base

    INVENTORY_FILENAME = "liveinv.xml"

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {})
      requires!(options, :username, :password)
      new(options).all
    end

    def self.get_quantity_file(options = {})
      requires!(options, :username, :password)
      new(options).get_quantity_file
    end

    def self.quantity(options = {})
      requires!(options, :username, :password)
      new(options).all
    end

    def all
      items    = []
      tempfile = get_file(INVENTORY_FILENAME)

      Nokogiri::XML(tempfile).xpath('//ZandersDataOut').each do |item|
        _map_hash = map_hash(item)

        items << _map_hash unless _map_hash.nil?
      end

      tempfile.close
      tempfile.unlink

      items
    end

    def get_quantity_file
      inventory_tempfile = get_file(INVENTORY_FILENAME)
      tempfile           = Tempfile.new

      Nokogiri::XML(inventory_tempfile).xpath('//ZandersDataOut').each do |item|
        tempfile.puts("#{content_for(item, 'ITEMNO')},#{content_for(item, 'AVAILABLE')}")
      end

      inventory_tempfile.close
      inventory_tempfile.unlink
      tempfile.close
      tempfile.path
    end

    private

    def map_hash(node)
      {
        item_identifier: content_for(node, 'ITEMNO'),
        quantity:        content_for(node, 'AVAILABLE'),
        price:           content_for(node, 'ITEMPRICE')
      }
    end

  end
end
