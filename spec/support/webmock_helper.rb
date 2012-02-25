# Geokit::Geocoders::GoogleGeocoder.geocode(

# def geo_stub
#   Geokit::Geocoders::GoogleGeocoder.stub(:geocode => geo_hash)
# end
# 
# def geo_hash(options = {})
#   {:lat   => 39.999,
#    :lng   => 39.999,
#    :city  => 'Austin',
#    :state => 'Tx'}.merge(options)
# end

def geo_body(options = {})
  body = <<-EOF
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://earth.google.com/kml/2.0">
    <Response>
      <name>100 spear st, san francisco, ca</name>
      <Status>
        <code>200</code>
        <request>geocode</request>
      </Status>
      <Placemark>
        <address>100 Spear St, San Francisco, CA 94105, USA</address>
        <AddressDetails Accuracy="8" xmlns="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0">
        <Country>
          <CountryNameCode>US</CountryNameCode>
          <AdministrativeArea>
            <AdministrativeAreaName>CA</AdministrativeAreaName>
            <SubAdministrativeArea>
              <SubAdministrativeAreaName>San Francisco</SubAdministrativeAreaName>
              <Locality>
                <LocalityName>San Francisco</LocalityName>
                <Thoroughfare>
                  <ThoroughfareName>100 Spear St</ThoroughfareName>
                </Thoroughfare>
                <PostalCode>
                  <PostalCodeNumber>94105</PostalCodeNumber>
                </PostalCode>
              </Locality>
            </SubAdministrativeArea>
          </AdministrativeArea>
        </Country>
        </AddressDetails>
          <Point>
            <coordinates>-122.393985,37.792501,0</coordinates>
            </Point>
      </Placemark>
    </Response>
  </kml>
  EOF
  # {:lat   => 39.999,
  #  :lng   => 39.999,
  #  :city  => 'Austin',
  #  :state => 'Tx'}.merge(options)
  body
end

def geo_web_mock(options = {})
  status = options.delete(:status)||200
  body   = geo_body
  stub_request(:any, %r{maps.google.com/maps/geo}).
    to_return(:status => status, :body => body, :headers => {})
end


def geo_name_web_mock
  austin_time = Timezone::Zone.new(:zone => "America/Chicago")
  Timezone::Zone.stub(:new).and_return( austin_time )
end