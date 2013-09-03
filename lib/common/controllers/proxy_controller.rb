# encoding: UTF-8

class ProxyController < Controller

  def initialize
    register_options(
      ['--proxy [protocol://]host:port', 'Supply a proxy (will override the one from conf/browser.conf.json). HTTP, SOCKS4 SOCKS4A and SOCKS5 are supported. If no protocol is given (format host:port), HTTP will be used'],
      ['--proxy-auth Username:Password', 'Supply the proxy login credentials (will override the one from conf/browser.conf.json).']
    )
  end

  def validate_parsed_options(options)
    if options[:proxy] && options[:proxy].index(':') == nil
      raise "Invalid proxy format '#{options[:proxy]}'. Should be [protocol://]host:port."
    end

    if options[:proxy_auth] && options[:proxy_auth].index(':') == nil
      raise 'Invalid proxy auth format, username:password expected'
    end

    super(options)
  end

  #
  ## Actions
  #

  def check_proxy(url)
    response = Browser.get(url)

    unless WpTarget::valid_response_codes.include?(response.code)
      raise render('error', response: response)
    end
  end
end