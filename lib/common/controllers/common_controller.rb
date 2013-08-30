# encoding: UTF-8

require_relative('controller.rb') # Line required as the current file is loaded before the controller.rb file.

class CommonController < Controller

  def initialize
    register_options(
      ['-v', '--verbose', 'Verbose output'],
      ['-V', '--version', 'Output the WPScan version'],
      ['--update', 'Update to the latest revision']
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

  # No Template for this one
  # All is done in cli format
  # Might change in the future (the problem is user interaction)
  def update
    updater = UpdaterFactory.get_updater(ROOT_DIR)

    if !updater.nil?
      if updater.has_local_changes?
        print "#{red('[!]')} Local file changes detected, an update will override local changes, do you want to continue updating? [y/n] "
        Readline.readline =~ /^y/i ? updater.reset_head : puts('Update aborted')
      end
      puts updater.update()
    else
      puts 'Svn / Git not installed, or wpscan has not been installed with one of them.'
      puts 'Update aborted'
    end
    exit(0)
  end

end
