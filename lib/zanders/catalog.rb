module Zanders
  class Catalog < Base

    CATALOG_FILENAME  = "zandersinv.xml"

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options

      if options[:full_product].present?
        self.load_descriptions
      end
    end

    def self.all(chunk_size = 15, options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(chunk_size, &block)
    end

    def all(chunk_size, &block)
      chunker   = Zanders::Chunker.new(chunk_size)
      tempfile  = get_file(CATALOG_FILENAME)
      xml_doc   = Nokogiri::XML(tempfile.open)

      xml_doc.xpath("//ZandersDataOut").each do |item|
        if chunker.is_full?
          yield(chunker.chunk)

          chunker.reset!
        else
          chunker.add(map_hash(item, @options[:full_product].present?))
        end
      end

      if chunker.chunk.count > 0
        yield(chunker.chunk)
      end

      tempfile.unlink
    end

    protected

    def map_hash(node, full_product = false)
      features = self.map_features(node)

      if full_product
        long_description = self.get_description(content_for(node, 'ITEMNO'))
      end

      {
        name:               content_for(node, 'ITEMDESCRIPTION'),
        upc:                content_for(node, 'ITEMUPC'),
        item_identifier:    content_for(node, 'ITEMNO'),
        quantity:           content_for(node, 'ITEMQTYAVAIL'),
        price:              content_for(node, 'ITEMPRICE'),
        short_description:  content_for(node, 'ITEMDESCRIPTION'),
        long_description:   long_description,
        category:           content_for(node, 'ITEMCATEGORYNAME'),
        product_type:       content_for(node, 'ITEMPRODUCTTYPE'),
        mfg_number:         content_for(node, 'ITEMMPN'),
        weight:             content_for(node, 'ITEMWEIGHT'),
        caliber:            features[:caliber],
        map_price:          content_for(node, 'ITEMMAPPRICE'),
        brand:              content_for(node, 'ITEMMANUFACTURER'),
        features:           features
      }
    end

    def get_description(item_number)
      description = @descriptions.find { |x| x[0] == item_number }

      if description
        description = description.last
        description.slice!("FEATURES")
      end

      description
    end

    def map_features(node)
      features = Hash.new

      node.css("ATTRIBUTE").each do |feature|
        features[feature.css("TITLE").text.strip] = feature.css("DATA").text.strip
      end

      features.delete_if { |k, v| v.to_s.blank? }
      features.transform_keys! { |k| k.gsub(/\s+/, '_').downcase }
      features.transform_keys! { |k| k.gsub(/[^0-9A-Za-z \_]/, '') }
      features.symbolize_keys!
    end

    def load_descriptions
      connect(@options) do |ftp|
        csv_tempfile = Tempfile.new

        ftp.chdir(Zanders.config.ftp_directory)
        ftp.getbinaryfile('detaildesctext.csv', csv_tempfile.path)

        @descriptions = CSV.read(csv_tempfile, { :col_sep => '~', :quote_char => "\x00" })
      end
    end

  end
end
