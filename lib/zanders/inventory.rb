module Zanders
  class Inventory < Base

    INVENTORY_FILENAME = "liveinv.csv"

    DEFAULT_SMART_OPTS = {
      convert_values_to_numeric: false,
      key_mapping: {
        available:  :quantity,
        itemnumber: :item_identifier
      },
      remove_unmapped_keys: true
    }

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
      connect(@options) do |ftp|
        begin
          csv_tempfile = Tempfile.new

          ftp.chdir(Zanders.config.ftp_directory)
          ftp.getbinaryfile(INVENTORY_FILENAME, csv_tempfile.path)

          opts = DEFAULT_SMART_OPTS.merge(chunk_size: chunk_size)

          SmarterCSV.process(csv_tempfile, opts) do |chunk|
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
