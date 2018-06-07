module SampleResponses

  def sample_item_info
    <<~XML
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:ns1="http://shop2.gzanders.com/webservice/items" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:enc="http://www.w3.org/2003/05/soap-encoding">
        <env:Body xmlns:rpc="http://www.w3.org/2003/05/soap-rpc">
          <ns1:getItemInfoResponse env:encodingStyle="http://www.w3.org/2003/05/soap-encoding">
            <rpc:result>return</rpc:result>
            <return xsi:type="ns2:Map">
              <item>
                <key xsi:type="xsd:string">returnCode</key>
                <value xsi:type="xsd:int">0</value>
              </item>
              <item>
                <key xsi:type="xsd:string">itemNumber</key>
                <value xsi:type="xsd:string">GSPEC0595A</value>
              </item>
              <item>
                <key xsi:type="xsd:string">itemDescription</key>
                <value xsi:type="xsd:string">BERETTA U22 NEOS .22LR</value>
              </item>
              <item>
                <key xsi:type="xsd:string">itemPrice</key>
                <value xsi:type="xsd:string">255.0000</value>
              </item>
              <item>
                <key xsi:type="xsd:string">itemWeight</key>
                <value xsi:type="xsd:string">3.700</value>
              </item>
              <item>
                <key xsi:type="xsd:string">numberAvailable</key>
                <value xsi:type="xsd:int">58</value>
              </item>
            </return>
          </ns1:getItemInfoResponse>
        </env:Body>
      </env:Envelope>
    XML
  end

  def sample_item_quantity
    <<~XML
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:ns1="http://shop2.gzanders.com/webservice/items" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:enc="http://www.w3.org/2003/05/soap-encoding">
        <env:Body xmlns:rpc="http://www.w3.org/2003/05/soap-rpc">
          <ns1:getItemInventoryResponse env:encodingStyle="http://www.w3.org/2003/05/soap-encoding">
            <rpc:result>return</rpc:result>
            <return xsi:type="ns2:Map">
              <item>
                <key xsi:type="xsd:string">returnCode</key>
                <value xsi:type="xsd:int">0</value>
              </item>
              <item>
                <key xsi:type="xsd:string">itemNumber</key>
                <value xsi:type="xsd:string">GSPEC0595A</value>
              </item>
              <item>
                <key xsi:type="xsd:string">numberAvailable</key>
                <value xsi:type="xsd:int">58</value>
              </item>
            </return>
          </ns1:getItemInventoryResponse>
        </env:Body>
      </env:Envelope>
    XML
  end

  def sample_ship_to_addresses
    <<~XML
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:ns1="http://shop2.gzanders.com/webservice/shiptoaddresses" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:enc="http://www.w3.org/2003/05/soap-encoding">
        <env:Body xmlns:rpc="http://www.w3.org/2003/05/soap-rpc">
          <ns1:useShipToResponse env:encodingStyle="http://www.w3.org/2003/05/soap-encoding">
            <rpc:result>return</rpc:result>
            <return xsi:type="ns2:Map">
              <item>
                <key xsi:type="xsd:string">returnCode</key>
                <value xsi:type="xsd:int">0</value>
              </item>
              <item>
                <key xsi:type="xsd:string">shipToAddress</key>
                <value xsi:type="ns2:Map">
                  <item>
                    <key xsi:type="xsd:string">ShipToCustomerNo</key>
                    <value xsi:type="xsd:string">416037</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToNo</key>
                    <value xsi:type="xsd:string">0003</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToName</key>
                    <value xsi:type="xsd:string">BlackJack</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToAddress1</key>
                    <value xsi:type="xsd:string">13043 Pong Springs Rd</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToAddress2</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToCity</key>
                    <value xsi:type="xsd:string">Austin</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToState</key>
                    <value xsi:type="xsd:string">TX</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToZipCode</key>
                    <value xsi:type="xsd:string">78729</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToCountry</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToExemptReasonCode</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToOutsideCityLimit</key>
                    <value xsi:type="xsd:string">N</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToShipViaCode</key>
                    <value xsi:type="xsd:string">BW</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToSalesmanNo</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToExemptExpireDate</key>
                    <value xsi:type="xsd:string">1969-12-31T00:00:00</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToUpsZone</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToTaxCode1</key>
                    <value xsi:type="xsd:string">OS</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToTaxCode2</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToTaxCode3</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToFreeFormFlag</key>
                    <value xsi:type="xsd:string">N</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToGeoCode</key>
                    <value xsi:type="xsd:string"/>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToTaxableFlag</key>
                    <value xsi:type="xsd:string">N</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToFFLNo</key>
                    <value xsi:type="xsd:string">57406616</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToFFLExpDate</key>
                    <value xsi:type="xsd:string">2019-09-01T00:00:00</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToXrefNo</key>
                    <value xsi:type="xsd:string">57406616</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToDeliveryLeadTime</key>
                    <value xsi:type="xsd:float">0</value>
                  </item>
                  <item>
                    <key xsi:type="xsd:string">ShipToOrderLocation</key>
                    <value xsi:type="xsd:string">01</value>
                  </item>
                </value>
              </item>
            </return>
          </ns1:useShipToResponse>
        </env:Body>
      </env:Envelope>
    XML
  end

end