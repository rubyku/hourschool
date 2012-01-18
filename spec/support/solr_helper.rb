## Mock out Solr
original_session  = Sunspot.session
Sunspot.session   = Sunspot::Rails::StubSessionProxy.new(original_session)