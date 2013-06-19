class HourschoolSubdomainRedirect
  PASSTHROUGH = %W{ hourschool hs-staging herokuapp }
  attr_accessor :env

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env

    if check_redirect?
      env['HTTP_HOST'] = redirect_http_host!
    end

    @app.call(env)
  end

  def redirect_http_host!
    account = Account.where(custom_domain: env['HTTP_HOST']).first
    return env['HTTP_HOST'].sub(/#{subdomain}/, account.subdomain) if account
    env['HTTP_HOST']
  end


  def check_redirect?
    return true  if subdomain.match(/test/)     # force true if has the word 'test' in it
    return false if PASSTHROUGH.include? domain # no redirect will come from a whitelabel domain
    true
  end

  def subdomain
    @subdomain ||= env['HTTP_HOST'].split('.').first if has_subdomain?
  end

  # take off subdomain foo.hourschool.com => hourschool.com
  # split via period ['hourschool', 'com'], take the first
  def domain
    @domain ||= env['HTTP_HOST'].sub(/#{subdomain}\./, '').split('.').first
  end

  # has at least two dots
  def has_subdomain?
    @has_subdomain ||= env['HTTP_HOST'].match(/.*\..*\..*/)
  end
end

# "HTTP_HOST"=>"foo.hourschool.dev"