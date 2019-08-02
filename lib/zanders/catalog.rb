module Zanders
  class Catalog < Base

    CATALOG_FILENAME = 'zandersinv.xml'.freeze
    ITEM_NODE_NAME   = 'ZandersDataOut'.freeze

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {})
      requires!(options, :username, :password)
      new(options).all
    end

    def all
      items    = []
      tempfile = get_file(CATALOG_FILENAME)

      Nokogiri::XML::Reader.from_io(tempfile, nil, Zanders.config.file_encoding).each do |reader|
        next unless reader.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        next unless reader.name == ITEM_NODE_NAME

        node = Nokogiri::XML.parse(reader.outer_xml)

        _map_hash = map_hash(node.css(ITEM_NODE_NAME))

        items << _map_hash unless _map_hash.nil?
      end

      tempfile.close
      tempfile.unlink

      items
    end

    protected

    def map_hash(node)
      features = map_features(node)

      {
        name:              content_for(node, 'ITEMDESCRIPTION'),
        upc:               content_for(node, 'ITEMUPC'),
        item_identifier:   content_for(node, 'ITEMNO'),
        quantity:          content_for(node, 'ITEMQTYAVAIL'),
        price:             content_for(node, 'ITEMPRICE'),
        short_description: content_for(node, 'ITEMDESCRIPTION'),
        category:          content_for(node, 'ITEMCATEGORYNAME'),
        mfg_number:        content_for(node, 'ITEMMPN'),
        weight:            content_for(node, 'ITEMWEIGHT'),
        caliber:           features[:caliber],
        map_price:         content_for(node, 'ITEMMAPPRICE'),
        brand:             content_for(node, 'ITEMMANUFACTURER'),
        features:          features
      }
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

  end
end
