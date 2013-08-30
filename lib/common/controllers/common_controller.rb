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

  # This is the first thing output
  # So is the format needs an opening tag or sort of (like json), it must be in the template
  def banner
    version
  end

  # Ending tag must be in the template (because the script will exit after tehe action)
  def version
    @version = REVISION ? "v#{WPSCAN_VERSION}r#{REVISION}" : "v#{WPSCAN_VERSION}"
  end

  # Ending tag must be in the template (because the script will exit after tehe action)
  def update
    updater = UpdaterFactory.get_updater(ROOT_DIR)

    if !updater.nil?
      if updater.has_local_changes?
        if user_interaction?
          print "#{red('[!]')} Local file changes detected, an update will override local changes, do you want to continue updating? [y/n] "

          if Readline.readline =~ /^y/i
            updater.reset_head
            @update_results = updater.update()
          else
            @aborted = true
          end
        else
          @local_changes = true
        end
      else
        @update_results = updater.update()
      end
    else
      @not_installed = true
    end
  end

end
