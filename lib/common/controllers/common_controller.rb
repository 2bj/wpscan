# encoding: UTF-8

require_relative('controller.rb') # Line required as the current file is loaded before the controller.rb file.

class CommonController < Controller

  def initialize
    @updater  = UpdaterFactory.get_updater(ROOT_DIR)
    @revision = @updater.local_revision_number if @updater
    @version  = @revision ? "v#{WPSCAN_VERSION}r#{@revision}" : "v#{WPSCAN_VERSION}"

    register_options(
      ['-v', '--verbose', 'Verbose output'],
      ['-V', '--version', 'Output the WPScan version'],
      ['--update', 'Update to the latest revision']
    )
  end

  #
  ## Actions
  #

  # This is the first output
  # So is the format needs an opening tag or sort of (like json), it must be in the template
  def banner
    puts render('banner')
  end

  # This is the last output
  # If the format needs a closing tag, it must be in the template
  # param [ Integer ] code The exit code (if > 0, an error occured)
  def exit(code = 0)
    puts render('exit', code: code)
    Kernel.exit(code)
  end

  def version
    puts render('version')
    exit
  end

  # param [ Exception ] e
  # param [ CustomOptionParser ] parser
  def option_error(e, parser)
    banner
    puts render('option_error', e: e, parser: parser)
    exit(1)
  end

  def update
    if !@updater.nil?
      if @updater.has_local_changes?
        if user_interaction?
          print "#{red('[!]')} Local file changes detected, an update will override local changes, do you want to continue updating? [y/N] "

          if Readline.readline =~ /^y/i
            @updater.reset_head
            @update_results = @updater.update()
          else
            @aborted = true
          end
        else
          @local_changes = true
        end
      else
        @update_results = @updater.update()
      end
    else
      @not_installed = true
    end

    puts render('update')
    exit
  end

end
