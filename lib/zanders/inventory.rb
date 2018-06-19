module Zanders
  class Inventory < Base

    INVENTORY_FILENAME = "liveinv.xml"

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(chunk_size = 100, options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(chunk_size, &block)
    end

    def self.get_quantity_file(options = {})
      requires!(options, :username, :password)
      new(options).get_quantity_file
    end

    def self.quantity(chunk_size = 100, options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(chunk_size, &block)
    end

    def self.get_file(options = {})
      requires!(options, :username, :password)
      new(options).get_file
    end

    def all(chunk_size, &block)
      chunker   = Zanders::Chunker.new(chunk_size)
      tempfile  = get_file(INVENTORY_FILENAME)
      xml_doc   = Nokogiri::XML(tempfile.open)

      xml_doc.xpath('//ZandersDataOut').each do |item|
        if chunker.is_full?
          yield(chunker.chunk)

          chunker.reset!
        else
          chunker.add(map_hash(item))
        end
      end

      if chunker.chunk.count > 0
        yield(chunker.chunk)
      end

      tempfile.unlink
    end

    def get_quantity_file
      inventory_tempfile  = get_file(INVENTORY_FILENAME)
      tempfile            = Tempfile.new
      xml_doc             = Nokogiri::XML(inventory_tempfile.open)

      xml_doc.xpath('//ZandersDataOut').each do |item|
        tempfile.puts("#{content_for(item, 'ITEMNO')},#{content_for(item, 'AVAILABLE')}")
      end

      inventory_tempfile.unlink
      tempfile.close

      tempfile.path
    end

    private

    def map_hash(node)
      {
        item_identifier:  content_for(node, 'ITEMNO'),
        quantity:         content_for(node, 'AVAILABLE'),
        price:            content_for(node, 'ITEMPRICE')
      }
    end

  end
end
