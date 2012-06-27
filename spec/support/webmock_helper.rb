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

def test_card
  {
    :card => {
      :number => 4000000000000002,
      :exp_month => 01,
      :exp_year => Time.now.year+1
    }
  } 
end

def mock_stripe(success=true)
  stripe_create_customer_response = <<-eos
    {
      "active_card": {
        "exp_month": 6,
        "exp_year": #{Time.now.year+1},
        "country": "US",
        "last4": "4242",
        "type": "Visa",
        "fingerprint": "nWCOrcBtvLPsBCze",
        "object": "card"
      },
      "account_balance": 0,
      "id": "cus_Uw1IRh2oPsmeD0",
      "livemode": false,
      "object": "customer",
      "created": 1340825802
    }
  eos

  stripe_retrieve_customer_response = <<-eos
    {
      "active_card": {
        "exp_month": 6,
        "exp_year": #{Time.now.year+1},
        "country": "US",
        "last4": "4242",
        "type": "Visa",
        "fingerprint": "nWCOrcBtvLPsBCze",
        "object": "card"
      },
      "account_balance": 0,
      "id": "cus_Uw1IRh2oPsmeD0",
      "livemode": false,
      "object": "customer",
      "created": 1340825802
    }
  eos

  create_charge_code = 200
  create_charge_response = <<-eos
    {
      "fee_details": [
        {
          "amount": 59,
          "application": null,
          "type": "stripe_fee",
          "currency": "usd",
          "description": "Stripe processing fees"
        }
      ],
      "refunded": false,
      "disputed": false,
      "paid": true,
      "amount": 1000,
      "card": {
        "exp_month": 6,
        "exp_year": #{Time.now.year+1},
        "country": "US",
        "last4": "4242",
        "type": "Visa",
        "fingerprint": "nWCOrcBtvLPsBCze",
        "object": "card"
      },
      "id": "ch_o31zAvJucofJQW",
      "livemode": false,
      "fee": 59,
      "customer": "cus_Uw1IRh2oPsmeD0",
      "currency": "usd",
      "object": "charge",
      "created": 1340826396,
      "description": "yipppe!"
    }
  eos

  create_charge_fail_code = 402
  create_charge_fail_response = <<-eos
    {
      "error": {
        "code": "card_declined",
        "type": "card_error",
        "message": "Your card was declined.",
        "charge": "ch_mel2AhyC9csmp6"
      }
    }
  eos

  stub_request(:post, "https://08YRJcknyvtlMDhneFawvZ8a3JWveCaW:@api.stripe.com/v1/customers").
  with(:body => {"card"=>{"number"=>"4000000000000002", "exp_month"=>"1", "exp_year"=>"#{Time.now.year+1}"}},
    :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'67', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Stripe/v1 RubyBindings/1.6.3', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.6.3","lang":"ruby","lang_version":"1.9.3 p-1 (2011-09-23)","platform":"x86_64-darwin11.3.0","publisher":"stripe","uname":"Darwin Chaps-MacBook-Pro.local 11.3.0 Darwin Kernel Version 11.3.0: Thu Jan 12 18:47:41 PST 2012; root:xnu-1699.24.23~1/RELEASE_X86_64 x86_64"}'}).
  to_return(:status => 200, :body => stripe_create_customer_response, :headers => {})

  stub_request(:get, "https://08YRJcknyvtlMDhneFawvZ8a3JWveCaW:@api.stripe.com/v1/customers/cus_Uw1IRh2oPsmeD0").
  with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Stripe/v1 RubyBindings/1.6.3', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.6.3","lang":"ruby","lang_version":"1.9.3 p-1 (2011-09-23)","platform":"x86_64-darwin11.3.0","publisher":"stripe","uname":"Darwin Chaps-MacBook-Pro.local 11.3.0 Darwin Kernel Version 11.3.0: Thu Jan 12 18:47:41 PST 2012; root:xnu-1699.24.23~1/RELEASE_X86_64 x86_64"}'}).
  to_return(:status => 200, :body => stripe_retrieve_customer_response, :headers => {})

  stub_request(:post, "https://08YRJcknyvtlMDhneFawvZ8a3JWveCaW:@api.stripe.com/v1/charges").
  with(:body => {"amount"=>"1000", "currency"=>"usd", "customer"=>"cus_Uw1IRh2oPsmeD0", "description"=>"Charge for June 06/27/12. Missions: fishing"},
    :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'124', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Stripe/v1 RubyBindings/1.6.3', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.6.3","lang":"ruby","lang_version":"1.9.3 p-1 (2011-09-23)","platform":"x86_64-darwin11.3.0","publisher":"stripe","uname":"Darwin Chaps-MacBook-Pro.local 11.3.0 Darwin Kernel Version 11.3.0: Thu Jan 12 18:47:41 PST 2012; root:xnu-1699.24.23~1/RELEASE_X86_64 x86_64"}'}).
  to_return(:status => (success ? create_charge_code : create_charge_fail_code), :body => (success ? create_charge_response : create_charge_fail_response), :headers => {})
end