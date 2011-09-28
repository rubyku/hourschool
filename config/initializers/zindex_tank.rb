INDEXAPI_URL = 'http://:59EVai37c4rcAB@895na.api.indextank.com'
INDEXAPI = IndexTank::Client.new INDEXAPI_URL
if Rails.env.production?
  INDEX = INDEXAPI.indexes "HSMainIndex"
else
  INDEX = INDEXAPI.indexes "HSTestIndex"
end