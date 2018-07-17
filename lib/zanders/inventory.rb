module Zanders
  class Inventory < Base

    INVENTORY_FILENAME = "liveinv.xml"

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all &block
    end

    def self.get_quantity_file(options = {})
      requires!(options, :username, :password)
      new(options).get_quantity_file
    end

    def self.quantity(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all &block
    end

    def all(&block)
      tempfile = get_file(INVENTORY_FILENAME)

      Nokogiri::XML(tempfile).xpath('//ZandersDataOut').each do |item|
        yield map_hash(item)
      end

      tempfile.close
      tempfile.unlink
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
