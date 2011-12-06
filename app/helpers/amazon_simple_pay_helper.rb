module AmazonSimplePayHelper
  
  if Rails.env.production?
    AMAZON_ACCESS_KEY = '11SEM03K88SD016FS1G2'
    AMAZON_PAYMENTS_ACCOUNT_ID = 'QSPTCWZLPHDP38FV5N8QNATH67MZR3ENH5Z7TD'
  else
    AMAZON_ACCESS_KEY = '11SEM03K88SD016FS1G2'
    AMAZON_PAYMENTS_ACCOUNT_ID = 'UUMRCJXJLISZ1EMCRML8HFRR8DIZKCK4XRDUR9'
  end


  def amazon_simple_pay_form_tag(options = {}, &block)
    sandbox = '-sandbox' unless Rails.env == 'production'
    pipeline_url = "https://authorize.payments.amazon.com/pba/paypipeline"
    html_options = { :action => pipeline_url, :method => :post }.merge(options)
    content = capture(&block)
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat(tag(:form, html_options, true))
    output << content
    output.safe_concat(hidden_field_tag('accessKey', AMAZON_ACCESS_KEY))
    output.safe_concat(hidden_field_tag('amazonPaymentsAccountId', AMAZON_PAYMENTS_ACCOUNT_ID))
    output.safe_concat(hidden_field_tag('amount', @course.price))
    output.safe_concat(hidden_field_tag('immediateReturn', '1'))
    output.safe_concat(hidden_field_tag('processImmediate', '1'))
    output.safe_concat(hidden_field_tag('cobrandingStyle', 'logo'))
    output.safe_concat(hidden_field_tag('returnUrl', register_with_amazon_url(:id => @course)))
    output.safe_concat("</form>")
  end

end
