# encoding: UTF-8

class WPScanInfoController < WPScanController

  def initialize
    register_options(
      ['-u', '--url TARGET_URL', 'The target url'],
      ["--format [#{Controller.allowed_formats.join(',')}]", 'The output format'],
      ['-o', '--output FILE', 'Output the results to the file supplied']
    )
  end

  def validate_parsed_options(options)
    raise 'The url is mandatory' unless options[:url] or options[:version]

    if options[:format] && !Controller.allowed_formats.include?(options[:format])
      raise "The format #{options[:format]} is not recognized or allowed"
    end

    super(options)
  end

  #
  ## Actions
  #
  def scan_start
    @start_time = Time.now
  end

  def scan_stop
    @stop_time = Time.now
    @elapsed = @stop_time - @start_time
  end

end
