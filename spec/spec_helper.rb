$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_support'
require 'active_support/core_ext'
require 'pp'

require 'zanders'

# Require all files from the /spec/support dir
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # configure options for dummy FTP connection
  config.before(:suite) do
    Zanders.configure do |config|
      config.ftp_host = "ftp.host.com"
    end
  end
end
