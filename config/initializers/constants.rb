module FacebookConfig; end

if Rails.env.development?
  FacebookConfig::ID     = '116183295130221'
  FacebookConfig::Secret = '83d6e8f67cf05b1710d073ac1af99a70'
else
  FacebookConfig::ID     = '144671482261988'
  FacebookConfig::Secret = 'a7f47f266872b6ce3847c9b7720bcdf4'
end

module TwitterConfig; end

if Rails.env.development?
  TwitterConfig::ID       = "k3BLACUuU7nRV6swgXZ6jw"
  TwitterConfig::Secret    = "blcQ4no16A11KYYRV4azhIQDyxPwPPdW3SMRdpLMI"
else
  TwitterConfig::ID       = "LK2Zf4LH6ro4rtmZDQ37pg"
  TwitterConfig::Secret    = "6hFNduoaepyEUZoqG4KbLRkdeWe5lCikUQw22hSY"
end


StateAbreviations = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AS' => 'America Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
  'FM' => 'Micronesia1',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MH' => 'Islands1',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PW' => 'Palau',
  'PA' => 'Pennsylvania',
  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Island',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}