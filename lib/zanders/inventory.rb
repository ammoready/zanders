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

    def self.quantity(chunk_size = 100, options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(chunk_size, &block)
    end

    def all(chunk_size, &block)
      chunker = Zanders::Chunker.new(chunk_size)

      connect(@options) do |ftp|
        begin
          tempfile = Tempfile.new

          ftp.chdir(Zanders.config.ftp_directory)
          ftp.getbinaryfile(INVENTORY_FILENAME, tempfile.path)

          xml_doc = Nokogiri::XML(tempfile)

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
        ensure
          ftp.close
        end
      end
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
