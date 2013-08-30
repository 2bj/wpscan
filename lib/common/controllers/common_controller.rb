# encoding: UTF-8

require_relative('controller.rb') # Line required as the current file is loaded before the controller.rb file.

class CommonController < Controller

  def initialize
    register_options(
      ['-v', '--verbose', 'Verbose output'],
      ['-V', '--version', 'Output the WPScan version']
    )
  end

  #
  ## Actions
  #
  def banner
    version
  end

  def version
    @version = REVISION ? "v#{WPSCAN_VERSION}r#{REVISION}" : "v#{WPSCAN_VERSION}"
  end
end
