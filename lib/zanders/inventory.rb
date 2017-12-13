module Zanders
  class Inventory < Base

    INVENTORY_FILENAME = "liveinv.csv"

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(chunk_size = 15, options = {}, &block)
      requires!(options, :username, :password)
      new(options).all(chunk_size, &block)
    end

    def all(chunk_size, &block)
      connect(@options) do |ftp|
        begin
          csv_tempfile = Tempfile.new

          ftp.chdir(Zanders.config.ftp_directory)
          ftp.getbinaryfile(INVENTORY_FILENAME, csv_tempfile.path)

          SmarterCSV.process(csv_tempfile, {
            chunk_size: chunk_size,
            convert_values_to_numeric: false,
            key_mapping: {
              available:  :quantity,
              itemnumber: :item_identifier,
              price1:     :price
            }
          }) do |chunk|
            chunk.each do |item|
              item.except!(:qty1, :qty2, :qty3, :price2, :price3)
            end

            yield(chunk)
          end

          csv_tempfile.unlink
        ensure
          ftp.close
        end
      end
    end

  end
end
