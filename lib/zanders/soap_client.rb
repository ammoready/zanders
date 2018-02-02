module Zanders
  class SoapClient < Base

    ##
    # == Item Service
    #
    # Return Codes
    # 0: Success
    # 1: Username and/or Password were incorrect
    # 2: There was a problem retrieving information on the item(s)

    protected

    def soap_client(api_url)
      namespaces = {
        "xmlns:env" => "http://www.w3.org/2003/05/soap-envelope",
        "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
        "xmlns:xsl" => "http://www.w3.org/2001/XMLSchema-Instance",
        "xmlns:ns2" => "http://xml.apache.org/xml-soap",
        "xmlns:enc" => "http://www.w3.org/2003/05/soap-encoding"
      }

      @soap_client ||= Savon.client do
        wsdl(api_url)
        namespaces(namespaces)
        namespace_identifier(:ns1)
        strip_namespaces true
        ssl_verify_mode :none

        if Zanders.config.debug?
          log(true)
          log_level(:debug)
          pretty_print_xml(true)
        end
      end
    end

  end
end
